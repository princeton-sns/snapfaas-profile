"""Ubuntu 16.04; kernel 4.15; Two connected nodes"""

#
# NOTE: This code was machine converted. An actual human would not
#       write code like this!
#

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# Import the Emulab specific extensions.
import geni.rspec.emulab as emulab

# Create a portal object,
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

pc.defineParameter("phystype1",  "Optional physical type for node1",
                   portal.ParameterType.STRING, "")
pc.defineParameter("phystype2",  "Optional physical type for node2",
                   portal.ParameterType.STRING, "")
pc.defineParameter("disk_image1",  "Optional disk image for node1",
                   portal.ParameterType.IMAGE, "urn:publicid:IDN+wisc.cloudlab.us+image+praxis-PG0:mongodb4.4-Ubuntu16")
pc.defineParameter("disk_image2",  "Optional disk image for node2",
                   portal.ParameterType.IMAGE, "urn:publicid:IDN+wisc.cloudlab.us+image+praxis-PG0:mongodb4.4-Ubuntu16")
params = pc.bindParameters()

# Create all the nodes.
nodes = []
phystypes = []
disk_images = []
phystypes.append(params.phystype1)
phystypes.append(params.phystype2)
disk_images.append(params.disk_image1)
disk_images.append(params.disk_image2)
for i in range(0, 2):
    node = request.RawPC("node%d" % (i + 1))
    if phystypes[i] != "":
        node.hardware_type = phystypes[i]
    node.disk_image = disk_images[i]
    node.addService(pg.Execute(shell="bash", command="/local/repository/setup.sh"))
        pass
    nodes.append(node)
    pass


# Create the link
nodeA = nodes[0]
nodeB = nodes[1]

iface1 = nodeA.addInterface()
iface2 = nodeB.addInterface()
link = request.Link()
link.addInterface(iface1)
link.addInterface(iface2)
link.best_effort = True
# link.link_multiplexing = True

# Print the generated rspec
pc.printRequestRSpec(request)
