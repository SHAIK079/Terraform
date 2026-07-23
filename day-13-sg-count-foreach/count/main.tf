resource "aws_instance" "name" {
    ami = "ami-002192a70217ac181"
    instance_type = "t3.micro"
    count = length(var.tags)
    tags = {
        Name = var.tags[count.index]
    }
  
}