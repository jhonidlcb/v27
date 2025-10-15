
-- Script para verificar y crear columnas SIFEN en la tabla invoices
-- Ejecutar en la base de datos PostgreSQL

-- 1. Verificar qué columnas SIFEN existen actualmente
SELECT 
    column_name, 
    data_type, 
    character_maximum_length,
    is_nullable
FROM 
    information_schema.columns
WHERE 
    table_schema = 'public' 
    AND table_name = 'invoices'
    AND column_name LIKE 'sifen%'
ORDER BY 
    column_name;

-- 2. Agregar columna sifen_qr si no existe
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'invoices' 
        AND column_name = 'sifen_qr'
    ) THEN
        ALTER TABLE invoices 
        ADD COLUMN sifen_qr VARCHAR(255);
        
        RAISE NOTICE 'Columna sifen_qr creada exitosamente';
    ELSE
        RAISE NOTICE 'Columna sifen_qr ya existe';
    END IF;
END $$;

-- 3. Verificar todas las columnas SIFEN después de la creación
SELECT 
    column_name, 
    data_type, 
    character_maximum_length,
    is_nullable
FROM 
    information_schema.columns
WHERE 
    table_schema = 'public' 
    AND table_name = 'invoices'
    AND column_name LIKE 'sifen%'
ORDER BY 
    column_name;

-- 4. Crear índice para la columna sifen_qr si no existe
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'invoices' 
        AND indexname = 'idx_invoices_sifen_qr'
    ) THEN
        CREATE INDEX idx_invoices_sifen_qr ON invoices(sifen_qr);
        RAISE NOTICE 'Índice idx_invoices_sifen_qr creado exitosamente';
    ELSE
        RAISE NOTICE 'Índice idx_invoices_sifen_qr ya existe';
    END IF;
END $$;

-- 5. Agregar comentarios descriptivos
COMMENT ON COLUMN invoices.sifen_qr IS 'URL del código QR para verificación en e-Kuatia SET';

-- 6. Mostrar estructura completa de columnas SIFEN
SELECT 
    c.column_name,
    c.data_type,
    c.character_maximum_length,
    c.is_nullable,
    pgd.description
FROM 
    information_schema.columns c
LEFT JOIN 
    pg_catalog.pg_statio_all_tables st ON c.table_schema = st.schemaname AND c.table_name = st.relname
LEFT JOIN 
    pg_catalog.pg_description pgd ON pgd.objoid = st.relid AND pgd.objsubid = c.ordinal_position
WHERE 
    c.table_schema = 'public' 
    AND c.table_name = 'invoices'
    AND c.column_name LIKE 'sifen%'
ORDER BY 
    c.column_name;
