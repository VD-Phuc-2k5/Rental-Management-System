-- Migration: rename momo_number -> vnpay_number on contracts
ALTER TABLE contracts RENAME COLUMN momo_number TO vnpay_number;
-- If any indexes or constraints reference the old column name, update them here.
