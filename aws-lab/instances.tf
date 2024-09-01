resource "aws_instance" "flarevm" {
  ami           = var.flarevm-ami
  instance_type = "t2.medium"

  network_interface {
    network_interface_id = aws_network_interface.network_interface_flarevm.id
    device_index         = 0
  }

  tags = {
    Name = "${var.environment}-flarevm"
  }

}

resource "aws_instance" "remnux" {
  ami           = var.remnux-ami
  instance_type = "t2.medium"

  network_interface {
    network_interface_id = aws_network_interface.network_interface_remnux.id
    device_index         = 0
  }

  tags = {
    Name = "${var.environment}-remnux"
  }

}

resource "aws_instance" "guacamole" {
  count = var.enable_guacamole ? 1 : 0
  ami   = var.guacamole-ami #

  instance_type = "t2.medium"

  network_interface {
    network_interface_id = aws_network_interface.network_interface_guacamole[0].id
    device_index         = 0
  }

  tags = {
    Name = "${var.environment}-guacamole"
  }

}

data "aws_instance" "guacamole_id" {
  count = var.enable_guacamole ? 1 : 0
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.environment}-guacamole"]
  }
  depends_on = [aws_instance.guacamole]
}

# Wait 5 minute for the Guacamole initialization
resource "time_sleep" "wait_5_min" {
  count      = var.enable_guacamole ? 1 : 0
  depends_on = [data.aws_instance.guacamole_id[0]]

  create_duration = "5m"
}

# netCUBE's Guacamole instance uses default creds: 
# username: guacadmin
# password: [the instance ID]
# so we don't need to retrieve the creds anymore

# Get Guacamole credentials from get-console-output
#data "external" "guacamole_credentials" {
#  count   = var.enable_guacamole ? 1 : 0
#  program = ["bash", "get_password.sh"]
#  query = {
#    "instanceid" = data.aws_instance.guacamole_id[0].id
#  }
#  depends_on = [time_sleep.wait_5_min]
#}
