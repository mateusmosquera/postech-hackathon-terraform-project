resource "aws_security_group" "db_security_group" {
  vpc_id      = aws_vpc.main.id
  name        = "db_security_group"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "postgres_db_subnet_group" {

  name       = "db-subnet-group"
  subnet_ids =  [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id,
  ]
  tags = {
    Name = "DB Subnet Group"
  }

}

resource "aws_db_instance" "postgresql_rds_patient_instance" {
  identifier          = "patient-db"
  allocated_storage   = 10
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t3.small"
  db_name             = "patients"
  username            = "username"
  password            = "password"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.postgres_db_subnet_group.name

}

resource "aws_db_instance" "postgresql_rds_med_instance" {
  identifier          = "med-db"
  allocated_storage   = 10
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t3.small"
  db_name             = "med"
  username            = "username"
  password            = "password"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.postgres_db_subnet_group.name

}

resource "aws_db_instance" "postgresql_rds_appointments_instance" {
  identifier          = "appointments-db"
  allocated_storage   = 10
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t3.small"
  db_name             = "appointments"
  username            = "username"
  password            = "password"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  db_subnet_group_name = aws_db_subnet_group.postgres_db_subnet_group.name

}


resource "aws_security_group_rule" "allow_db_access" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]

  security_group_id = aws_security_group.db_security_group.id
}
