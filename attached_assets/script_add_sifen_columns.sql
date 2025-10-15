
-- Script de migración para agregar columnas SIFEN
-- Ejecutar manualmente en la base de datos

-- Agregar columnas SIFEN a la tabla invoices
ALTER TABLE invoices 
ADD COLUMN IF NOT EXISTS sifen_cdc VARCHAR(44),
ADD COLUMN IF NOT EXISTS sifen_protocolo VARCHAR(50),
ADD COLUMN IF NOT EXISTS sifen_estado VARCHAR(20),
ADD COLUMN IF NOT EXISTS sifen_xml TEXT,
ADD COLUMN IF NOT EXISTS sifen_fecha_envio TIMESTAMP,
ADD COLUMN IF NOT EXISTS sifen_mensaje_error TEXT;

-- Crear índice para búsquedas por CDC
CREATE INDEX IF NOT EXISTS idx_invoices_sifen_cdc ON invoices(sifen_cdc);

-- Crear índice para filtrar por estado SIFEN
CREATE INDEX IF NOT EXISTS idx_invoices_sifen_estado ON invoices(sifen_estado);

-- Comentarios descriptivos
COMMENT ON COLUMN invoices.sifen_cdc IS 'Código de Control SIFEN de 44 dígitos';
COMMENT ON COLUMN invoices.sifen_protocolo IS 'Protocolo de autorización devuelto por SIFEN';
COMMENT ON COLUMN invoices.sifen_estado IS 'Estado de la factura en SIFEN: aceptado, rechazado, pendiente';
COMMENT ON COLUMN invoices.sifen_xml IS 'XML completo enviado a SIFEN';
COMMENT ON COLUMN invoices.sifen_fecha_envio IS 'Fecha y hora de envío a SIFEN';
COMMENT ON COLUMN invoices.sifen_mensaje_error IS 'Mensaje de error si la factura fue rechazada por SIFEN';
