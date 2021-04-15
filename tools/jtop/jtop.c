/*
file: jtop.c
actor: marijn stevens (marijnstevens@gmail.com)
description: This application collects system information; and than
output it in JSON format.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <string.h>

typedef int bool;
#define true 1
#define false 0

long double a[4], b[4], loadavg;
double startTime, endTime;

char str[4096];

struct sysinfo info;
extern const struct seq_operations cpuinfo_op;

///
/// Time function for benchmarking
///
double getTime()
{
    struct timeval t;
    gettimeofday(&t, NULL);
    return t.tv_sec + t.tv_usec*1e-6;
}

///
/// Get the cpu usage from /proc/stat
///
void cpustat(long double* a){
  FILE *fp;
  fp = fopen("/proc/stat","r");
  fscanf(fp,"%*s %Lf %Lf %Lf %Lf",&a[0],&a[1],&a[2],&a[3]);
  fclose(fp);
}

///
/// Return all disk info from df in json
///
char* diskStat(){
  FILE *fp;
  char path[1035];
  char data[4096];

  /* Open the command for reading. */
  fp = popen("df -P", "r");
  if (fp == NULL) {
    printf("Failed to run command\n" );
    exit(1);
  }

  char index = 0;
  char diskName[15], use[15], diskPath[15];
  long total, used, avaible;

  // Prepare formating
  char *target = data;

  target += sprintf(target, "%s", "[");

  /* Read the output a line at a time - output it. */
  while (fgets(path, sizeof(path), fp) != NULL) {

    fscanf(fp, "%s %lu %lu %lu %s %s", diskName, &total, &used, &avaible, use, diskPath);

    bool allowDisk = strcmp(diskName,"tmpfs") != 0 && strcmp(diskName,"devtmpfs") != 0;

    if(allowDisk) {
      if(index > 0){
        target += sprintf(target, "%s", ", ");
      }

      target += sprintf(target,
        "{ \"name\": \"%s\", \"total\": %lu, \"used\": %lu, \"avaible\": %lu, \"use\": \"%s\", \"mount\": \"%s\" }",
         diskName, total, used, avaible, use, diskPath);

      index++;
    }
  }

  target += sprintf(target, "%s", "]");

  /* close */
  pclose(fp);

  int length = strlen(data);
  char *str = malloc (length * sizeof(char));
  strncpy (str, data, length);
  return str;
}

int main(void)
{
    double sleep = 250.0;

    startTime = getTime();

    cpustat(a);

    // Get the memory information from the linux kernel
    sysinfo( &info );
    long double memusage = 1.0-(long double)(info.freeram) / info.totalram;

    char* disks = diskStat();

    endTime = getTime();

    // compensate for the average time it takes to sample sysinfo.
    double ajustment = 0.2 + (endTime-startTime)*1000;
    //printf("ajustment: %f\n", ajustment);

    double sleepy = (sleep-ajustment);
    sleepy = sleepy < 0 ? 0.1 : sleepy;

    // usleep works in microseconds; we multiply to get miliseconds
    usleep(sleepy*1000);

    cpustat(b);

    loadavg = 100*((b[0]+b[1]+b[2]) - (a[0]+a[1]+a[2])) / ((b[0]+b[1]+b[2]+b[3]) - (a[0]+a[1]+a[2]+a[3]));

    endTime = getTime();


    // Prepare formating
    char *target = str;

    //printf("processing: elapsed: %fms\n", (endTime-startTime));

    target += sprintf(target, "%s", "{\n");
    target += sprintf(target, " \"cpu\": %Lf, \n", loadavg);
    target += sprintf(target, " \"uptime\": %ld, \n",  info.uptime);
    target += sprintf(target, " \"procs\": %d, \n",  info.procs);
    target += sprintf(target, " \"memory\":{ \"usage\": %Lf, \n", memusage);
    target += sprintf(target, " \"totalram\": %lu, \n", info.totalram);
    target += sprintf(target, " \"freeram\": %lu, \n", ( info.totalram - info.freeram));
    target += sprintf(target, " \"sharedram\": %lu, \n", info.sharedram);
    target += sprintf(target, " \"bufferram\": %lu, \n", info.bufferram);
    target += sprintf(target, " \"totalswap\": %lu, \n", info.totalswap);
    target += sprintf(target, " \"freeswap\": %lu \n", info.freeswap);

    target += sprintf(target, "%s", "},\n");

    target += sprintf(target, " \"disks\": %s, \n", disks);
    target += sprintf(target, " \"measurement\": %f, \n", (endTime-startTime));
    target += sprintf(target, " \"measurement-error\": %f \n", (sleep/1000) - (endTime-startTime));

    target += sprintf(target, "%s", "}\n");

    printf("%s", str);


    return(0);
}
