from solver import *
import os 
import argparse
import xml.etree.ElementTree as ET


def parse_input(Input):
    tree= ET.parse(Input)
    root=tree.getroot()
    a=root.tag
    file_type=""
    array=[]
    for net in root.findall('net'):
        array.append([])
        for connector in net.findall('connector'):
            array[-1].append(connector.attrib)
            for part in connector.findall('part'):
                array[-1].append(part.attrib)
                file_type="fritzing"
    return generate_netlist(file_type,array),file_type

def generate_netlist(file_type,array):
    nets=[]
    for i in range(len(array)):
            pin_number=""
            name=""
            for j in range(len(array[i])):
                if j>0 and j%2==0:
                    name=array[i][j]['name']
                    continue
                elif j==0:
                    nets.append([])
                    nets[-1].append("net"+str(len(nets)))
                    pin_number=str(int(array[i][j]['id'][9:])+1)
                else:
                    nets[-1].append(array[i][j]['label'])
                    label=array[i][j]['label']
                    if (label.startswith("C") and (name=="+" or name=="-")):
                        nets[-1][-1]=nets[-1][-1][0]+"P"+nets[-1][-1][1:]
                    nets[-1].append(pin_number)
    return nets

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file', help='Input file', required=True)
args = parser.parse_args()
inputFile= args.file
fileName=os.path.splitext(inputFile)[0]
Input=inputFile
array=[]
nets,file_type=parse_input(Input)

solver(nets,file_type,fileName)
