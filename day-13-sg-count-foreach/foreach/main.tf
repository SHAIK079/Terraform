resource "aws_instance" "name" {
    ami = "ami-002192a70217ac181"
    instance_type = "t3.micro"

    # for_each tells Terraform to create one aws_instance for each item in the set.
    # Here, var.tags is converted to a set with toset(), so each element becomes a separate resource.
    # The resource address will be aws_instance.name[<value>].
    for_each  = toset(var.tags)

    tags = {
        # each.key is the current element from the set during iteration.
        # Because we used a set, each.key is the tag string value itself.
        Name = each.key
    }
}
