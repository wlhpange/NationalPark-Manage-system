from django.db import models

# Create your models here.


class Inspector(models.Model):
    inspectorid = models.CharField(primary_key=True, max_length=3)
    inspectorpw = models.CharField(max_length=8, blank=True)

    class Meta:
        db_table = 'inspector'


class Lake(models.Model):
    lakeid = models.CharField(primary_key=True, max_length=3)
    lakename = models.CharField(max_length=20, blank=True, null=True)
    lakesize = models.IntegerField(blank=True, null=True)
    lakeloc = models.CharField(max_length=20, blank=True, null=True)
    waterlevel = models.IntegerField(blank=True, null=True)
    gatestate = models.BooleanField(blank=True, null=True)

    class Meta:
        db_table = 'lake'


class Manager(models.Model):
    mid = models.CharField(primary_key=True, max_length=3)
    mpw = models.CharField(max_length=8)
    mname = models.CharField(max_length=20)
    msex = models.BooleanField(null=True)
    mage = models.IntegerField(null=True)

    class Meta:
        db_table = 'manager'


class Parking(models.Model):
    parkingid = models.CharField(primary_key=True, max_length=3)
    havenum = models.IntegerField(blank=True, null=True)
    maxnum = models.IntegerField(blank=True, null=True)
    parkingloc = models.CharField(max_length=20, blank=True, null=True)
    parkingstate = models.BooleanField(blank=True, null=True)

    class Meta:
        db_table = 'parking'


class Road(models.Model):
    roadid = models.CharField(primary_key=True, max_length=3)
    roadlength = models.IntegerField(blank=True, null=True)
    roadname = models.CharField(max_length=20, blank=True, null=True)
    potholesnum = models.IntegerField(blank=True, null=True)

    class Meta:
        db_table = 'road'


class Toilet(models.Model):
    toiletid = models.CharField(primary_key=True, max_length=3)
    peoplenum = models.IntegerField(blank=True, null=True)
    toiletloc = models.CharField(max_length=20, blank=True, null=True)
    toiletclean = models.BooleanField(blank=True, null=True)

    class Meta:
        db_table = 'toilet'


class Tree(models.Model):
    treeid = models.CharField(primary_key=True, max_length=3)
    treespe = models.CharField(max_length=20, blank=True, null=True)
    treeloc = models.CharField(max_length=20, blank=True, null=True)
    insectbugs = models.BooleanField(blank=True, null=True)
    treewater = models.BooleanField(blank=True, null=True)

    class Meta:
        db_table = 'tree'


class Visitor(models.Model):
    vtel = models.CharField(primary_key=True, max_length=11)
    vname = models.CharField(max_length=10)
    vtime = models.CharField(max_length=4)

    class Meta:
        db_table = 'visitor'



class Book(models.Model):
    timeid = models.CharField(primary_key=True, max_length=4)
    booked = models.IntegerField(blank=True, null=True)
    maxnum = models.IntegerField(blank=True, null=True)
    bookstate = models.BooleanField(blank=True, null=True)

    class Meta:
        db_table = 'book'

