# Create VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "lab_ig" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Public Subnet
resource "aws_subnet" "lab_public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_ig.id
}

# Associate the public subnet with the routing table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.lab_public_subnet.id
  route_table_id = aws_route_table.public.id
}


# Create Security groups FlareVM - with outbound internet
resource "aws_security_group" "security_group_flarevm_outbound_internet" {
  count       = var.enable_guacamole ? 1 : 0
  name        = "security_group_flarevm outbound_internet"
  description = "Allow outbound internet access"
  vpc_id      = aws_vpc.lab_vpc.id

ingress {
    description = "Allow RDP inbound traffic"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.5/32"]
  }

  egress {
    description = "Allow all protocols outbound to any subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-flarevm-internet"
  }
}

# Create Security groups FlareVM - no internet
resource "aws_security_group" "security_group_flarevm_no_internet" {
  count       = var.enable_guacamole ? 1 : 0
  name        = "security_group_flarevm no_internet"
  description = "Allow inbound from local subnet"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "Allow inbound traffic from local subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    description = "Allow outbound to local subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }

  tags = {
    Name = "${var.environment}-flarevm-no-internet"
  }
}

# Create Security groups REMnux - with outbound internet
resource "aws_security_group" "security_group_remnux_outbound_internet" {
  count       = var.enable_guacamole ? 1 : 0
  name        = "security_group_remnux outbound_internet"
  description = "Allow outbound internet access"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "Allow all protocols inbound from local subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }
  egress {
    description = "Allow all protocols outbound to any subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-remnux-internet"
  }
}

# Create Security groups REMnux - no internet
resource "aws_security_group" "security_group_remnux_no_internet" {
  count       = var.enable_guacamole ? 1 : 0
  name        = "security_group_remnux no_internet"
  description = "Allow in/out from local subnet"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "Allow inbound from local subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }


  egress {
    description = "Allow outbound to local subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/24"]
  }

  tags = {
    Name = "${var.environment}-remnux-no-internet"
  }
}

# Create Security Group for Guacamole
resource "aws_security_group" "security_group_guacamole" {
  count       = var.enable_guacamole ? 1 : 0
  name        = "security_group_guacamole"
  description = "Allow HTTPS from the Internet"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description      = "Allow HTTPS inbound traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.environment}-guacamole"
  }
}

# Create Network Interface for FlareVM
resource "aws_network_interface" "network_interface_flarevm" {
  subnet_id       = aws_subnet.lab_public_subnet.id
  private_ips     = ["10.0.0.4"]
  security_groups = [aws_security_group.security_group_flarevm_no_internet[0].id]

  tags = {
    Name = "${var.environment}-interface-flarevm"
  }
}

# Create Network Interface for REMnux
resource "aws_network_interface" "network_interface_remnux" {
  subnet_id       = aws_subnet.lab_public_subnet.id
  private_ips     = ["10.0.0.6"]
  security_groups = [aws_security_group.security_group_remnux_no_internet[0].id]

  tags = {
    Name = "${var.environment}-interface-remnux"
  }
}

# Create Network Interface for Guacamole
resource "aws_network_interface" "network_interface_guacamole" {
  count           = var.enable_guacamole ? 1 : 0
  subnet_id       = aws_subnet.lab_public_subnet.id
  private_ips     = ["10.0.0.5"]
  security_groups = [aws_security_group.security_group_guacamole[0].id]

  tags = {
    Name = "${var.environment}-interface-guacamole"
  }
}
