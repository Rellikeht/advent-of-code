#!/bin/awk -f

BEGIN {a=0}
{
	if ($1=="down")
	{a+=$2}
	else if ($1=="up")
	{a-=$2}
	else
	{h+=$2;v+=$2*a}
}
END {print h, v, h*v}
