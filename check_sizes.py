import sys
sys.path.insert(0, 'tools/mapmerge2')
from dmm import DMM

m = DMM.from_file('_maps/map_files/MetaStation/MetaStation.dmm')
print('MetaStation size:', m.size)

m2 = DMM.from_file('_maps/map_files/Deltastation/DeltaStation2.dmm')
print('DeltaStation size:', m2.size)
