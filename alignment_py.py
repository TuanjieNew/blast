#!/usr/bin/env python
#fn:loc_alig.py



def alignment(seqq1,seq2):

    len1=len(seq1)
    len2=len(seq2)

    match=2;
    mismatch=-1;
    gap=-1
    #i=0
    #j=0
    matrix=[([0] *(len1+1)) for i in range(len2+1)]
    matrix[0][0]=0
    for j in range(len(seq1)):
        j+=1
        matrix[0][j]=0
        
    for i in range(len(seq2)):
        i=i+1
        matrix[i][0]=0
    max_i=0
    max_j=0
    max_score=0
    #i=0
    #j=0

    for i in range(len(seq2)):
        i=i+1
        for j in range(len(seq1)):
            j=j+1
            #print(j)
            #print(i)
            #print(matrix[i])
            diag_score=0
            left_score=0
            up_score=0

            letter1=seq1[j-1:j]
            letter2=seq2[i-1:i]

            if letter1==letter2:
                diag_score=matrix[i-1][j-1]+match
            else:
                diag_score=matrix[i-1][j-1]+mismatch
            up_score=matrix[i-1][j]+gap
            left_score=matrix[i][j-1]+gap
            #print('diag: '+str(diag_score))
            #print('up: '+str(up_score))
            #print('left: '+str(left_score))
            if diag_score <=0 and up_score<=0 and left_score<=0:
                matrix[i][j]=0
                continue
            #choose the highest socre
            if diag_score >=up_score:
                if diag_score>=left_score:
                    matrix[i][j]=diag_score
                else:
                    matrix[i][j]=left_score

            else:
                if left_score>=up_score:
                    matrix[i][j]=left_score
                else:
                    matrix[i][j]=up_score

            #set maximum score
            if matrix[i][j]>max_score:
                max_i=i
                max_j=j
                max_score=matrix[i][j]
    #trace back

    print('max_j: '+str(max_j))
    print('max_i: '+str(max_i))
    align1=''
    align2=''
    #j=max_j
    #i=max_i
    j=len1
    i=len2
    equal_num=0

    while 1:
        if matrix[i][j]==0:
            break
        if matrix[i-1][j-1]>=matrix[i-1][j]:
            if matrix[i-1][j-1]>=matrix[i][j-1]:

                align1=align1+seq1[j-1:j]
                align2=align2+seq2[i-1:i]
                j-=1
                i-=1
            else:
                align1=align1+seq1[j-1:j]
                align2=align2+'-'
                j-=1
        else:
            if matrix[i-1][j]>=matrix[i][j-1]:
                align1=align1+'-'
                align2=align2+seq2[i-1:i]
                i-=1
            else:
                align1=align1+seq1[j-1:j]
                align2=align2+'-'
                j-=1
    align1=align1[::-1]
    align2=align2[::-1]
    print('seq1: '+align1)
    print('seq2: '+align2)
    c=0
    equ_num=0
    non_eq=0
    while c < len(align1):
        if align1[c]==align2[c]:
            equ_num+=1
        else:
            non_eq+=1
        if non_eq>5:
            return non_eq+equ_num
        c+=1
        

seq1='MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAED'
seq2='MALWMRFLPLLALLVVWEPKPAQAFVKQHLCGPHLVEALYLVCGERGFFYTPKSRREVED'
eq_num=alignment(seq1,seq2)
print('eq_num: '+str(eq_num))





