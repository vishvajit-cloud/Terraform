resource "aws_vpc" "first_vpc"{
    tags = {
        Name = "my_vpc"
    }

    cidr_block = "10.0.0.0/16"
    

}

resource "aws_subnet" "public_sub"{
    tags = {
    Name = "public"
    }
    vpc_id = aws_vpc.first_vpc.id
    cidr_block = "10.0.0.0/18"
}




resource "aws_instance" "server"{
    ami = var.ami                                                                #calling variable from ami variable block
    instance_type = var.instance-type                                            #calling variable from instance_type variable block
 #  count = 3
    subnet_id = aws_subnet.public_sub.id
    vpc_security_group_ids = [aws_security_group.my_sg.id] 
    tags = {
        Name = "server"                                                          #   ${count.index+1}
    }
 /*  lifecycle {
        create_before_destroy = true
        prevent_destroy = true
    }
*/ 
}

resource "aws_security_group" "my_sg"{
    
    name = "serverSec"
    description = "allow ssh, http, https, and mysql"
    vpc_id = aws_vpc.first_vpc.id

    ingress{
    
        description = "allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
       
        description = "allow https"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        
        description = "allow 3306"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        
        description = "allow all traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-for-ENI(eth0)"
    }
    
}