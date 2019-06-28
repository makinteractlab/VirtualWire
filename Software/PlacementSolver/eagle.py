from solver import *
import os 
import argparse


def creating_nets():
#creating final nets
    nets=[]
    already_exist=0
    for i in range(len(line_req)):
        already_exist=0
        for j in range(len(nets)):
            if line_req[i][2]==nets[j][0]:
                already_exist=1
                break
        if already_exist==1:
            nets[j].append(line_req[i][0])
            nets[j].append(line_req[i][1])
        else:
            nets.append([])
            nets[-1].append(line_req[i][2])
            nets[-1].append(line_req[i][0])
            nets[-1].append(line_req[i][1])
    return nets


#changing component names to match consistency
def changing_names():
    #changing names
    for i in range(len(line_req)):
        if line_req[i][0].startswith("G"):
            line_req[i][0]="VCC"+line_req[i][0][1:]
        if line_req[i][0].startswith("X"):
            line_req[i][0]="U"+line_req[i][0][1:]

def reading_file():
    list1=[]
    counter=0
    for line in f:
        counter+=1
        if counter>8:
            list1.append(line)
    line=[]
    counter=0
    temp_term=""
    for i in range(len(list1)):
        temp=list1[i]
        counter=0
        line.append([])
        for j in range(len(temp)):
            if temp[j]==" " or temp[j]=="\n":
                if temp_term=="":
                    continue
                else:
                    line[-1].append(temp_term)
                    temp_term=""
            else:
                temp_term=temp_term+temp[j]
    line[:] = (value for value in line if value != [])
    return(line)

def eleminate_unnecessary_data():
    line_req=[]
    comp_pos=0
    for i in range(len(line)):
        counter=0
        line_req.append([])
        for j in range(len(line[i])):
            if len(line[i])%2==1:
                comp_pos=i
                counter+=1
                if counter%2==1:
                    line_req[-1].append(line[i][j])
            else:
                if counter==0:
                    line_req[-1].append(line[comp_pos][0])
                counter+=1
                if counter%2==0:
                    line_req[-1].append(line[i][j])
        if len(line_req[-1])%3!=0:
            line_req[-1].pop()
    line_req[:] = (value for value in line_req if value != [])
    return line_req


def assigning_nets():
    already_existing_nets=[]
    for i in range(len(line_req)):
        if not(line_req[i][2] in already_existing_nets):
            already_existing_nets.append(line_req[i][2])


    no_of_nets=len(already_existing_nets)

    for i in range(len(line_req)):
        if line_req[i][2].startswith("*"):
            line_req[i][2]="Net"+str(no_of_nets)
            no_of_nets+=1
def minor_editing():
    counter=1
    temp=""
    for i in range(len(line_req)):
        if temp==line_req[i][0]:
            counter+=1
        else:
            counter=1
            temp=line_req[i][0]
        line_req[i][1]=str(counter)

    for i in range(len(line_req)):
        if line_req[i][2].startswith("N$"):
            line_req[i][2]=line_req[i][2].replace("$","et")



parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file', help='Input file', required=True)
args = parser.parse_args()
inputFile= args.file
fileName=os.path.splitext(inputFile)[0]
Input=inputFile
f= open(inputFile,'r')
line=reading_file()
line_req=eleminate_unnecessary_data()

minor_editing()
assigning_nets()
changing_names()
nets=creating_nets()

file_type="kicad"
solver(nets,file_type,fileName)
