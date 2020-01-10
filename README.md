# TACC & BASH Basics
## How to access Lonestar
- either SSH from a terminal or use an application such as PuTTy
- There are 3 login nodes, but if you don't specify one then you will get first available
- `ssh -Y username@ls5.tacc.utexas.edu`
    + the `-Y` enables X11 forwarding and lets you use guis, i.e. fslview
- DO NOT RUN CODE ON LOGIN NODE
    + that being said, I usually feel ok running scripts that move files or generate text files for batch jobs. But, when in doubt, go `idev`

## Moving around Lonestar
- everyone gets a Home and Work directory
    + when you log in you should see the total space and % used of each
- environment variables are your friend, no settup required
    + `cd $HOME` takes you to Home, always
    + `cd $WORK` takes you to Work, always
- `vim` is going to be your friend, whether you like it or not. (steep learning curve)
    + this is the command line text editor that is easiest to use for quick edits of code when you don't want to go through pulling and pushing from local
- `l` or `ls` with the different flags `-a` are useful for seeing whats in a directory, `rm` to delete things, `mv` to rename/move things, `-R` to delete or move folders

## Putting files on Lonestar
### Files
- I use `scp` to transfer files and folders. To transfer a `folder` you have to have the `-r` flag, but not for files.
- In general, a basic command is `scp -r "from/here" "to/here"` 
- putting a folder onto TACC
    + `scp -r "/Users/ach3377/CCX-bids" ach3377@ls5.tacc.utexas.edu:"/work/ 05426/ach3377/lonestar/CCX-bids"`
- From TACC to local
    + `scp -r ach3377@ls5.tacc.utexas.edu:"/work/05426/ach3377/lonestar/CCX-bids/derivatives/fmriprep" "/Users/ach3377/"`

### Code
- You _could_ use scp as above, but for code I would use `git`!
- There are tonnes of tutorials for basic usage of git out there, including the coding_club repo on the dunsmoorlab github
- If you ever get an SSL error, try the following `git config --global http.sslverify false`

## Running Code
Just to reiterate, this is how _I_ do it, not necessarily the best way.

### idev
sometimes, you really need to be able to debug your code in real time. idev jobs allow you to interactively use a compute node for some time

To start an idev session: `idev -m 120`, where `-m` is how long you are requesting it for (2hrs is the max)

Its always better to test if something will run in idev first, instead of submitting jobs to test. If your jobs error enough times in a certain time period, you _can_ get penalized by TACC.

### launch
I use `launch`, which I believe can be loaded using `module load launcher`

The reason I like using `launch` is that it allows you to very easily create a job that will run code in parallel on multiple different Nodes.

A basic command looks like this:
`launch -N 2 -n 4 -J myjobname -s myjob.txt -m myemail@utexas.edu -p normal -r 05:00:00 -A fMRI-Fear-Conditioni`

Where the contents of `myjob.txt` will look like this:

```
python3 my_script.py -s 1
python3 my_script.py -s 2
python3 my_script.py -s 3
python3 my_script.py -s 4
```

- `-n` is how many "jobs" or "tasks" you are telling TACC you want to run, and `launch` takes in exactly 1 line of the `myjob.txt` as a job
    + if the number of lines in `myjob.txt` > `n`, the first `n` are run, and when one is completed the next is started
- `-N` is how many Compute Nodes you are requesting. TACC will then attempt to run `n/N` jobs per Node
    + each compute node has 24 logical processors, each of which is hyperthreaded, allowing you to use up to 48 logical processors at a time. 
    + IT IS UP TO YOU TO PARALLIZE YOUR CODE, if you do not, then it may be better to take a "tall" approach, i.e. requesting 1 node with many jobs for a long time
    + in this case, I the code in `my_script.py` knows to look for and use mulitple CPUs
    + I prefer a "wide" approach, i.e. requesting lots of Nodes, often with a ratio of `n/N` = 1, and running for short time
    + Keep in mind that each `N` node has a set amount of memory. Running a high number of `n` per `N`, such as lots of fsl feats, can easily result in out of memory errors & wasted time
- `-J` is the name of the job as it will appear on the queue
- `-s` is the job text file
    + make sure that the text file has executable permissions
    + `chmod u+x myjob.txt`
- `-m` if you want to get email notifications when your job starts/finishes/errors
- `-p` priority of the job, should always be `normal`
- `-r` is the runtime of the job before it is cut off
    + always overestimate here, but know that the longer you say you need it for and the more `N` nodes you request will increase the wait time on queue
- `-A` is the allocation to bill

I just keep 1 `launch.sh` script around, and then edit the name of the text file and time, and then submit a job `sh launch.sh`

### Checking job status
- `showq` displays all current jobs, `showq -u` filters for just your jobs
- to cancel a job before or while running, `scancel JOBID`, where jobid is the # of the job as found in queue
