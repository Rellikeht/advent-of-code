#!/bin/awk -f
{
	if ($1=="down")
	{v+=$2}
	else if ($1=="up")
	{v-=$2}
	else
	{h+=$2}
}
END {print h, v, h*v}
