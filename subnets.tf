data "aws_availability_zones" "available" {}

resource "aws_subnet" "tf-eks-PF" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.tf-eks-PF.id}"

  tags = "${
    map(
     "Name", "terraform-eks-PFCluster",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "tf-eks-PF" {
  vpc_id = "${aws_vpc.tf-eks-PF.id}"

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_route_table" "tf-eks-PF" {
  vpc_id = "${aws_vpc.tf-eks-PF.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf-eks-PF.id}"
  }
}

resource "aws_route_table_association" "tf-eks-PF" {
  count = 2

  subnet_id      = "${aws_subnet.tf-eks-PF.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf-eks-PF.id}"
}
