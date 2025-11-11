import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix

# 1. read read read
df = pd.read_csv("flood_data.csv")

feature_cols = ["dem", "slope", "dist2river", "landcover"]  # feature columns
label_col = "label"  # 0/1 non-flood/flood

X = df[feature_cols].values # array of shape (n_samples, n_features)
y = df[label_col].values # array of shape (n_samples,) 

# 2. train / test
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=1234, stratify=y # random_state=1234 for reproducibility, stratify=y to keep class distribution
)

# 3. baseline Random Forest, RandomForestClassifier is for classification tasks
#https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html
rf = RandomForestClassifier( 
    n_estimators=100,
    max_depth=None,
    max_features="sqrt",
    n_jobs=-1,
    random_state=1234,
)
rf.fit(X_train, y_train)

# 4. predict & evaluate
y_pred = rf.predict(X_test)

acc  = accuracy_score(y_test, y_pred)
prec = precision_score(y_test, y_pred, zero_division=0)
rec  = recall_score(y_test, y_pred, zero_division=0)
f1   = f1_score(y_test, y_pred, zero_division=0)
cm   = confusion_matrix(y_test, y_pred)

print("Accuracy :", acc)
print("Precision:", prec)
print("Recall   :", rec)
print("F1       :", f1)
print("Confusion matrix:\n", cm)

# 5. Feature importance (for sensitivity analysis)
importances = rf.feature_importances_
for name, imp in zip(feature_cols, importances):
    print(f"{name}: {imp:.3f}")