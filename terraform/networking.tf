resource "aws_vpc" "this" {
  enable_dns_hostnames = true

  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${aws_vpc.this.tags.Name}-internet-gateway"
  }
}

# TODO: Look into using loops for creating the subnet and the RTA. Reference: https://github.com/btkrausen/hashicorp/blob/master/terraform/Hands-On%20Labs/Section%2002%20-%20Understand%20IAC%20Concepts/02%20-%20Benefits_of_Infrastructure_as_Code.md#task-7-prepare-files-and-credentials-for-using-terraform-to-deploy-cloud-resources
resource "aws_subnet" "a" {
  depends_on = [aws_internet_gateway.this]

  availability_zone = "${var.region}a"
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 4, 0)
  vpc_id            = aws_vpc.this.id

  tags = {
    Name = "${aws_vpc.this.tags.Name}-subnet-a"
  }
}

resource "aws_subnet" "b" {
  depends_on = [aws_internet_gateway.this]

  availability_zone = "${var.region}b"
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 4, 1)
  vpc_id            = aws_vpc.this.id

  tags = {
    Name = "${aws_vpc.this.tags.Name}-subnet-b"
  }
}

resource "aws_subnet" "c" {
  depends_on = [aws_internet_gateway.this]

  availability_zone = "${var.region}c"
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 4, 2)
  vpc_id            = aws_vpc.this.id

  tags = {
    Name = "${aws_vpc.this.tags.Name}-subnet-c"
  }
}

resource "aws_route_table_association" "public-subnet-a" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-subnet-b" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-subnet-c" {
  subnet_id      = aws_subnet.c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "base" {
  name   = "${var.project}-sg-base"
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "Base Security Group for ${var.project}"
    Environment = "Global"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_anywhere" {
  security_group_id = aws_security_group.base.id
  description       = "Allow SSH anywhere"
  cidr_ipv4         = local.any_ipv4_address # 0.0.0.0/0
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_anywhere" {
  security_group_id = aws_security_group.base.id
  description       = "Allow HTTP anywhere"
  cidr_ipv4         = local.any_ipv4_address # 0.0.0.0/0
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_anywhere" {
  security_group_id = aws_security_group.base.id
  description       = "Allow HTTPS anywhere"
  cidr_ipv4         = local.any_ipv4_address # 0.0.0.0/0
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outgoing_anywhere" {
  security_group_id = aws_security_group.base.id
  description       = "Allow all outgoing traffic"
  cidr_ipv4         = local.any_ipv4_address # 0.0.0.0/0
  ip_protocol       = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_database_private_network" {
  security_group_id = aws_security_group.base.id
  description       = "Allow devices in VPC to connect to MySQL databases"
  cidr_ipv4         = aws_vpc.this.cidr_block
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}

resource "aws_route_table" "public" {
  depends_on = [aws_internet_gateway.this]

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.any_ipv4_address # 0.0.0.0/0
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project}-route-table-public"
  }
}

// For RDS use
resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-db-subnet-group"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]

  tags = {
    Name = "DB Subnet Group for ${var.project}"
  }
}