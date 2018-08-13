# Codebook

### The purpose of this codebook is to display the variables useed in the 
### creation of the tidy.txt file created for this project.

## Variables used:

### THe variables used in this project exclude the variables that end with a "Freq"
### as this would result in providing the frequency and not the mean.

```{r}
list(colnames(data_F)[3:68])
```

## Excercise identifiers

```{r}
list(colnames(data_F)[1:2])
```

## Activity labe;s

```{r}
list(activity_labels$V2)
```
     