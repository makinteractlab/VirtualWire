import math
import json
import copy
import xml.etree.ElementTree as ET
import argparse
import os
from random import choice

#priority sequence 
def priority(comp):
    counter= 0
    for a in range(len(comp)):
        if comp[a][0].startswith(("U","SW")):
            temp= comp[a]
            comp[a]=comp[counter]
            comp[counter]=temp
            counter+=1
    
    return(comp)

def sorting(comp):
    for i in range(len(comp)):
        if comp[i][0].startswith(("U","SW")):
            counter=1
            for j in range(2,len(comp[i]),2):
                a=comp[i].index(str(int(counter)))
                temp=comp[i][a]
                comp[i][a]= comp[i][j]
                comp[i][j]=temp
                temp=comp[i][a-1]
                comp[i][a-1]=comp[i][j-1]
                comp[i][j-1]=temp
                if j<((len(comp[i])/2)-1):
                    counter+=1
                elif j<(len(comp[i])/2):
                    counter=counter+((len(comp[i])-1)/4)
                else:
                    counter-=1

    return(comp)


def no_of_rows(nets,comp,row_assign,no_rows_on_board):#assignment of rows to nets
    next_empty=1
    free_rows=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    i=0
    while(comp[i][0].startswith("U")):
        U_size= int(len(comp[i])/2)
        already_exist=-1
        for a in range(int(U_size/2)):#no of pins in IC/2 for one side
            for j in range(len(row_assign)):
                if comp[i][(a*2)+1]==row_assign[j][0]:
                    already_exist=j
            if already_exist!=-1:
                row_assign[already_exist].append(str(next_empty))
                free_rows[next_empty-1]=1
                next_empty+=1
            else:
                row_assign.append([])
                row_assign[len(row_assign)-1].append(comp[i][(a*2)+1])
                row_assign[len(row_assign)-1].append(str(next_empty))
                free_rows[next_empty-1]=1
                next_empty+=1
            already_exist=-1
        temp=next_empty   
        next_empty=int(next_empty-(U_size/2)+(no_rows_on_board/2))
        for a in range(int(U_size/2)):#no of pins in IC/2 for one side
            for j in range(len(row_assign)):
                if comp[i][(a*2)+1+U_size]==row_assign[j][0]:
                    already_exist=j
            if already_exist!=-1:
                row_assign[already_exist].append(str(next_empty))
                free_rows[next_empty-1]=1
                next_empty+=1
            else:
                row_assign.append([])
                row_assign[len(row_assign)-1].append(comp[i][(a*2)+1+U_size])
                row_assign[len(row_assign)-1].append(str(next_empty))
                free_rows[next_empty-1]=1
                next_empty+=1
            already_exist=-1
            if 0 not in free_rows:
                print("circuit to big")
                exit()
        next_empty=temp
        i+=1

    for i in range(len(nets)):
        #check if already assigned
        already_assign=0
        for j in range(len(row_assign)):
            if nets[i][0]==row_assign[j][0]:
                already_assign=len(row_assign[j])-1
        if already_assign==0:
            row_assign.append([])
            row_assign[len(row_assign)-1].append(nets[i][0])

        more_assign=math.ceil(((len(nets[i])-1)/2)/4)-already_assign
        while more_assign>0:
            if 0 not in free_rows:
                print("circuit to big")
                exit()
            next_empty=choice([i for i in range(0,no_rows_on_board) if free_rows[i] != 1])+1
            for k in range(len(row_assign)):
                if row_assign[k][0]==nets[i][0]:
                    row_assign[k].append(str(next_empty))
                    free_rows[next_empty-1]=1
                    more_assign-=1
                    break
                    
    return row_assign
    

def correcting_pin_names(comp,file_type):
    for i in range(len(comp)):
        if comp[i][0].startswith(("LED","CP","D","J","SP")):
            for j in range(2,len(comp[i]),2):
                if comp[i][j]=="1":
                    if file_type=="fritzing":
                        comp[i][j]="cathode"
                    else:
                        comp[i][j]="anode"
                if comp[i][j]=="2":
                    if file_type=="fritzing":
                        comp[i][j]="anode"
                    else:
                        comp[i][j]="cathode"
        elif comp[i][0].startswith(("VCC","BT")):
            for j in range(2,len(comp[i]),2):
                if comp[i][j]=="1":
                    if file_type=="fritzing":
                        comp[i][j]="negative"
                    else:
                        comp[i][j]="positive"
                if comp[i][j]=="2":
                    if file_type=="fritzing":
                        comp[i][j]="positive"
                    else:
                        comp[i][j]="negative"
        elif comp[i][0].startswith("Q"):
            for j in range(2,len(comp[i]),2):
                if comp[i][j]=="1":
                    comp[i][j]="emitter"
                if comp[i][j]=="2":
                    comp[i][j]="base"
                if comp[i][j]=="3":
                    comp[i][j]="collector"
        else:
            for j in range(2,len(comp[i]),2):
                comp[i][j]="none"

    return(comp)



#final printing and adding columns
def adding_column(comp,row_assign,no_rows_on_board,bb):
    for i in range(len(comp)):
        #print()
        #print (comp[i][0],end=" ")
        for j in range (1,len(comp[i])):
            if j%2==1:
                for k in range (len(row_assign)):
                    if row_assign[k][0]== comp[i][j]:
                        for l in range(1,len(row_assign[k])):
                            assignment_done=0
                            if comp[i][0].startswith("U"):
                                possible_rows=1
                            else:
                                possible_rows=5
                            for t in range(possible_rows):
                                if bb[int(row_assign[k][l])-1][t]==0 and int(row_assign[k][l])>(no_rows_on_board/2):
                                    #print(row_assign[k][l]+str(t+1),end=" ")
                                    comp[i][j]=[row_assign[k][l],str(t+1)]
                                    bb[int(row_assign[k][l])-1][t]=1

                                    assignment_done=1
                                    break

                                elif int(row_assign[k][l])<=int(no_rows_on_board/2) and bb[int(row_assign[k][l])-1][4-t]==0:
                                    #print(row_assign[k][l]+str(5-t),end=" ")
                                    comp[i][j]=[row_assign[k][l],str(5-t)]
                                    bb[int(row_assign[k][l])-1][4-t]=1

                                    assignment_done=1
                                    break

                                else:
                                    continue
                                
                            if assignment_done==1:
                                break

    return(comp)


#adding wires as components to the circuit
def addingwire(nets,comp,row_assign,no_rows_on_board):    
    counter=1
    for i in range(len(row_assign)):
        for j in range(2, len(row_assign[i])):
            
            if int(row_assign[i][j-1])>(no_rows_on_board/2):
                x="5"
            else:
                x="1" 
            if int(row_assign[i][j])>(no_rows_on_board/2):
                y="5"
            else:
                y="1"
            comp.append([])
            comp[-1].append("wire"+str(counter))
            comp[-1].extend(([row_assign[i][j-1],x],"1",[row_assign[i][j],y],"2"))
            counter+=1

    for i in range(len(nets)):
        if nets[i][0].startswith("N"):
            continue
        else:
            comp.append([])
            comp[-1].append(nets[i][0])
            temp=nets[i][1]
            for j in range(len(comp)):
                if comp[j][0]==temp:
                    pos=comp[j].index(nets[i][2])
                    comp[-1].extend(([-1,-1],"1",comp[j][pos-1],"2"))
                    break
            counter+=1
            

def parse_input(Input):
    tree= ET.parse(Input)
    root=tree.getroot()
    a=root.tag
    file_type=""
    array=[]
    for nets in root.findall('nets'):
        for net in nets.findall('net'):
            array.append([])
            array[-1].append(net.attrib)
            for node in net.findall('node'):
                array[-1].append(node.attrib)
                file_type="kicad"


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
    #print(array)
    if file_type=="kicad":
        for i in range(len(array)):
            for j in range(len(array[i])):
                if j==0:
                    nets.append([])
                    nets[-1].append(array[i][j]['name'])
                else:
                    nets[-1].append(array[i][j]['ref'])
                    nets[-1].append(array[i][j]['pin'])
    if file_type=="fritzing":
        for i in range(len(array)):
            pin_number=""
            for j in range(len(array[i])):
                if j>0 and j%2==0:
                    continue
                elif j==0:
                    nets.append([])
                    nets[-1].append("net"+str(len(nets)))
                    pin_number=str(int(array[i][j]['id'][9:])+1)
                else:
                    nets[-1].append(array[i][j]['label'])
                    nets[-1].append(pin_number)
    return nets

def component(nets):
    comp=[]
    for i in range(len(nets)):
        for j in range(1, len(nets[i])):
            if j%2 ==1:#if component
                component_exist=0
                for a in range(len(comp)):
                    if nets[i][j]==comp[a][0]:
                        component_exist=1
                        break
                if component_exist==1:
                    continue
                else:
                    comp.append([])
                    comp[len(comp)-1].append(nets[i][j])
            else:
                temp_comp = nets[i][j-1]
                for a in range(len(comp)):
                    if comp[a][0]==temp_comp:
                        comp[a].append(nets[i][0])
                        comp[a].append(nets[i][j])
    
    return comp

def write_json(nets,comp,file_type,fileName):
    #writing onto json 

    fileName=fileName+".json"
    f=open(fileName,"w")
    list0=[]
    list3=[]
    for i in range(len(nets)):
        list1=[]
        for j in range(1,len(nets[i])-1,2):
            obj= {"component":nets[i][j],"pin":"connector"+str(int(nets[i][j+1])-1)}
            list1.append(obj)
        obj={"name":nets[i][0],"connector":list1}
        list0.append(obj)

    #CHANGING COMP TO SUIT YOONJI

    comp_new=copy.deepcopy(comp)
    comp=correcting_pin_names(comp,file_type)
    for i in range(len(comp_new)):
        list2=[]
        for j in range(1,len(comp_new[i])-1,2):
            obj2={"id":"connector"+str(int(comp_new[i][j+1])-1),"type":comp[i][j+1],"position":[int(x) for x in comp[i][j]]}
            list2.append(obj2)
        obj2 ={"label":comp[i][0],"connector":list2}
        list3.append(obj2)

    final_obj={"sketch":"test.fz","net":list0,"component":list3}
    json.dump(final_obj,f)

def final_sorting(comp):
    for i in range(len(comp)):
        counter=1
        for j in range(2,len(comp[i]),2):
            a=comp[i].index(str(counter))
            counter+=1
            temp= comp[i][j]
            comp[i][j]=comp[i][a]
            comp[i][a]=temp
            temp= comp[i][j-1]
            comp[i][j-1]=comp[i][a-1]
            comp[i][a-1]=temp
    return comp
def solver(nets,file_type,fileName):

    
    bb = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
    no_rows_on_board=len(bb)
    row_assign=[]
    comp=component(nets)
    comp=sorting(comp)
    comp=priority(comp)
    row_assign=no_of_rows(nets,comp,row_assign,no_rows_on_board)
    comp=adding_column(comp,row_assign,no_rows_on_board,bb)
    addingwire(nets,comp,row_assign,no_rows_on_board)
    comp=final_sorting(comp)
    write_json(nets,comp,file_type,fileName)
    print("executed")
    


