variable "project" {
  description = "Project"
  default     = "dtc-de-course-411807"

}

variable "location" {
  description = "Project location"
  default     = "asia-southeast1"

}

variable "region" {
  description = "Project region"
  default     = "asia-southeast1"

}

variable "gcs_storage_bucket" {
  description = "MyBigquery bucket Name"
  default     = "dtc-de-course-411807-terra-bucket"

}


variable "bq_dataset_name" {
  description = "MyBigquery Dataset Name"
  default     = "demo_dataset"

}


variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"

}


