CREATE TYPE invoice_status AS ENUM ('draft', 'finalized', 'paid', 'void');
CREATE TYPE invoice_item_type AS ENUM ('rent', 'electric', 'water', 'service', 'adjustment');

CREATE TABLE meter_readings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
  month text NOT NULL,
  old_electric integer NOT NULL,
  new_electric integer NOT NULL,
  old_water integer NOT NULL,
  new_water integer NOT NULL,
  source text,
  created_by uuid REFERENCES users(id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX meter_readings_room_month_unique
  ON meter_readings(room_id, month);

CREATE TABLE invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
  tenant_id uuid NOT NULL REFERENCES users(id),
  landlord_id uuid NOT NULL REFERENCES users(id),
  month text NOT NULL,
  status invoice_status NOT NULL DEFAULT 'draft',
  due_date date,
  total numeric(12, 2) NOT NULL DEFAULT 0,
  created_by uuid REFERENCES users(id),
  finalized_at timestamptz,
  paid_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX invoices_room_month_unique
  ON invoices(room_id, month);

CREATE TABLE invoice_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id uuid NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  type invoice_item_type NOT NULL,
  quantity numeric(12, 2) NOT NULL DEFAULT 1,
  unit_price numeric(12, 2) NOT NULL DEFAULT 0,
  amount numeric(12, 2) NOT NULL DEFAULT 0,
  description text
);
