-- ============================================
-- Index Optimization Examples
-- Real-world patterns from 15+ years of DBA work
-- ============================================

-- ❌ BEFORE: Full table scan (slow)
EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_id = 1001;

-- ✅ AFTER: Add index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- ============================================
-- Composite Index - Column order matters!
-- ============================================

-- Query pattern: filter by status, sort by date
-- ❌ Wrong order (inefficient)
CREATE INDEX idx_wrong ON orders(order_date, status);

-- ✅ Right order (matches WHERE + ORDER BY)
CREATE INDEX idx_correct ON orders(status, order_date DESC);

-- ============================================
-- Covering Index - Avoids table lookup
-- ============================================
CREATE INDEX idx_covering_orders
    ON orders(customer_id, status)
    INCLUDE (total_amount, order_date);

-- ============================================
-- Partial Index - Reduces index size
-- ============================================
-- Only index pending orders (small subset)
CREATE INDEX idx_pending_orders
    ON orders(order_date)
    WHERE status = 'pending';
