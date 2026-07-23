variable "tags" {
    # type = list(string) means this variable expects a list of strings.
    # In this example, each string becomes one item for the for_each iteration.
    type = list(string)

    # default provides a fallback value when no other value is supplied.
    # Here the list contains two names, so Terraform will create two aws_instance resources.
    default = ["sharukh", "prabhas"]
}
