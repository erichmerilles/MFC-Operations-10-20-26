-- Preserve product and site links held by withdrawals, invoices, and Sales Orders.
-- Run once against withdrawal_qb after taking a database backup.
-- This changes delete behavior only; nullable references and existing rows are preserved.

ALTER TABLE withdrawal_items
    DROP FOREIGN KEY fk_wi_product,
    ADD CONSTRAINT fk_wi_product_restrict FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT;

ALTER TABLE invoice_items
    DROP FOREIGN KEY fk_ii_product,
    ADD CONSTRAINT fk_ii_product_restrict FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    DROP FOREIGN KEY fk_ii_site,
    ADD CONSTRAINT fk_ii_site_restrict FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE RESTRICT;

ALTER TABLE sales_order_items
    DROP FOREIGN KEY fk_soi_product,
    ADD CONSTRAINT fk_soi_product_restrict FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    DROP FOREIGN KEY fk_soi_site,
    ADD CONSTRAINT fk_soi_site_restrict FOREIGN KEY (site_id) REFERENCES sites(id) ON DELETE RESTRICT;
