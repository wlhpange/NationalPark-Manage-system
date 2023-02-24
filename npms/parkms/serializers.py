from parkms.models import *
from rest_framework import serializers


class Bookserializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = ('timeid','booked','maxnum','bookstate')


class Inspectorserializer(serializers.ModelSerializer):
    class Meta:
        model = Inspector
        fields = ('inspectorid','inspectorpw')


class Lakeserializer(serializers.ModelSerializer):
    class Meta:
        model = Lake
        fields = ('lakeid','lakename','lakesize','lakeloc','waterlevel','gatestate')


class Managerserializer(serializers.ModelSerializer):
    class Meta:
        model = Manager
        fields = ('mid','mpw','mname','msex','mage')


class Parkingserializer(serializers.ModelSerializer):
    class Meta:
        model = Parking
        fields = ('parkingid','havenum','maxnum','parkingloc','parkingstate')


class Roadserializer(serializers.ModelSerializer):
    class Meta:
        model = Road
        fields = ('roadid','roadlength','roadname','potholesnum')


class Toiletserializer(serializers.ModelSerializer):
    class Meta:
        model = Toilet
        fields = ('toiletid','peoplenum','toiletloc','toiletclean')


class Treeserializer(serializers.ModelSerializer):
    class Meta:
        model = Tree
        fields = ('treeid','treespe','treeloc','insectbugs','treewater')


class Vistorserializer(serializers.ModelSerializer):
    class Meta:
        model = Visitor
        fields = ('vtel','vname','vtime')