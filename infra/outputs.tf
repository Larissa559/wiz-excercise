output "mongo_instance_public_ip" {
  value = aws_instance.mongo.public_ip
}

output "s3_backup_bucket" {
  value = aws_s3_bucket.db_backups.bucket
}

output "ecr_repo_uri" {
  value = aws_ecr_repository.wiz_app.repository_url
}

output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${aws_eks_cluster.this.name} --region ${var.aws_region}"
}
