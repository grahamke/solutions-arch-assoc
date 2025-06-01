# This is possible, but I ran into problems when the VPC was updated with an egress-only IGW. terraform
# re-evaluated the VPC entry and saw the assign_generated_ipv6_cidr_block was not set and changed it to null, then
# it planned on associating a new IPv6 block, but when applying the bastion host still had an associated
# IPv6 address and it was not released. Causing the following error:
#
# aws_vpc.demo_vpc: Modifying... [id=vpc-12345678900b80ca2]
#╷
#│ Error: updating EC2 VPC (vpc-12345678900b80ca2): disassociating IPv6 CIDR block (vpc-cidr-assoc-0638aed9c4b413c66): 
#   operation error EC2: DisassociateVpcCidrBlock, https response error StatusCode: 400, 
#   RequestID: de2a38ee-1781-4463-9126-ced49d3219cc, api error InvalidCidrBlock.InUse: 
#   The vpc vpc-12345678900b80ca2 currently has a subnet within CIDR block 2600:1f16:1848:5c00::/56
# resource aws_vpc_ipv6_cidr_block_association vpc_ipv6 {
#   vpc_id = aws_vpc.demo_vpc.id
#   assign_generated_ipv6_cidr_block = true
# }