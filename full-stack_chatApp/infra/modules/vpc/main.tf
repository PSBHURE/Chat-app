resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-vpc" }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-public-subnet-${count.index}" }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-private-subnet-${count.index}" }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-igw" }
  )
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-nat-gateway" }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-public-rt" }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    var.default_tags,
    { Name = "${var.env}-private-rt" }
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

 subnet_id = aws_subnet.public[count.index].id
 route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

#Newly added for jenkins and docker server
resource "aws_security_group" "CustomCG" {
  name = "CustomCG"
  description = "Allow all ports to make it genric"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "CustomCG"
    Description = "CustomCG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Allow_all_inbound" {
  security_group_id = aws_security_group.CustomCG.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
    tags = {
    Name = "Allow_all_inbound"
    description = "Allow all inbound traffic"
  }
}

resource "aws_vpc_security_group_egress_rule" "Allow_All_Outbound" {
  security_group_id = aws_security_group.CustomCG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = {
    Name        = "Allow_all_Outbound"
    Description = "Allow all outbound traffic"
  }
}

resource "aws_key_pair" "chat_app_key_1" {
  key_name = "chat_app_key_1"
  #public_key = file("chat_app_key_1.pub")
  public_key = file("${path.module}/chat_app_key_1.pub")
}

# resource "aws_instance" "Docker_Server" {
#   depends_on = [ aws_security_group.CustomCG ]
#   ami = var.ami_type
#   instance_type = var.instance_type
#   key_name = aws_key_pair.chat_app_key_1.key_name
#   subnet_id = aws_subnet.public[0].id
#   vpc_security_group_ids = [aws_security_group.CustomCG.id]
#   associate_public_ip_address = true

#   tags = {
#     Name = "Docker_Server"
#     Description = "Docker_Server"
#   }
#   root_block_device {
#     volume_size = var.volume_size
#     volume_type = "gp3"
#   }
# }

resource "aws_instance" "Jenkins_Server" {
    depends_on = [ aws_security_group.CustomCG ]
  ami = var.ami_type
  instance_type = var.instance_type
  key_name = aws_key_pair.chat_app_key_1.key_name
  subnet_id = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.CustomCG.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins_Server"
    Description = "Jenkins_Server"
  }
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }
}