resource "aws_s3_bucket" "medical_records" {
  bucket = "health-med-medical-records-bucket"
  tags = {
    Name = "Medical Records"
  }
}
