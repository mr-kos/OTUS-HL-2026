opensearch:
  hosts:
%{ for name, node in cluster_nodes ~}
    ${name}:
      ansible_host: ${node.ip}
      ansible_user: ${node.user}
      ansible_password: ${node.password}
      opensearch_node_ip: ${node.ip}
%{ endfor ~}
  vars:
    roles:
      - master
      - data
      - ingest
