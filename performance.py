import sys
import numpy as np

def get_preds(fname):
    preds = []
    with open(fname, 'r') as f:
        for line in f:
            v=line.rstrip().split()
            #preds.append([v[0],float(v[2]),int(v[3])])
            preds.append([v[0],float(v[1]),int(v[2])])

    return preds



def get_cm(preds, th=0.001):
    cm = np.zeros((2, 2))
    n = len(preds)
    for k in range(n):
        j = 0
        i = preds[k][2]
        if preds[k][1] <= th:
            j=1
        cm[i][j] += 1
    return cm

def get_accuracy(cm):
    return (cm[0][0]+cm[1][1])/(cm.sum())

def get_mcc(cm):
    tp =cm[1,1]
    tn =cm[0,0]
    fp =cm[0,1]
    fn =cm[1,0]
    d = ((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn))
    mcc = (tp*tn-fp*fn)/np.sqrt(d) 
    return mcc



if __name__ == "__main__":
    fname = sys.argv[1]
    th = float(sys.argv[2])
    preds = get_preds(fname)
    cm = get_cm(preds, th)
    q2 = get_accuracy(cm)
    mcc = get_mcc(cm)
    print("TH.", th, "Q2: ", q2, "MCC: ", mcc)
    print(f"TH. {th} Q2: {q2} MCC: {mcc}")
    print(f"TN: {cm[0][0]} | FP: {cm[0][1]}")
    print(f"FN: {cm[1][0]} | TP: {cm[1][1]}\n")