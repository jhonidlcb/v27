
-- Ampliar campo sifen_qr para soportar URLs largas de FacturaSend
ALTER TABLE invoices 
ALTER COLUMN sifen_qr TYPE VARCHAR(1000);

-- Verificar el cambio
SELECT 
    column_name, 
    data_type, 
    character_maximum_length
FROM 
    information_schema.columns
WHERE 
    table_schema = 'public' 
    AND table_name = 'invoices'
    AND column_name = 'sifen_qr';

-- Mostrar facturas que necesitan actualización (tienen paymentStageId pero no CDC)
SELECT 
    id, 
    invoice_number, 
    payment_stage_id,
    sifen_cdc,
    CASE 
        WHEN sifen_qr IS NULL THEN 'Sin QR'
        WHEN LENGTH(sifen_qr) > 255 THEN 'QR largo (' || LENGTH(sifen_qr) || ' chars)'
        ELSE 'QR OK'
    END as qr_status
FROM invoices 
WHERE payment_stage_id IS NOT NULL
ORDER BY id DESC;
