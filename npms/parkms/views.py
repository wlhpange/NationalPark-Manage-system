import json
from django.views.decorators.csrf import csrf_exempt
from django.http.response import Http404, HttpResponse, HttpResponseBadRequest, JsonResponse
from django.shortcuts import render, redirect
from parkms.serializers import *
from rest_framework.parsers import JSONParser


@csrf_exempt
def appointment(request):
    if request.method == 'POST':  # 接收到POST类型的请求
        json_body = JSONParser().parse(request)  # JSON数据序列化
        u = json_body
        # 数据库中若不存在输入的日期，则显示没有该日期
        if Book.objects.filter(timeid=u['vtime']).count() == 0:
            return HttpResponse("nodate")
        # 判断数据库中该日期已满，则显示已满
        elif Book.objects.filter(timeid=u['vtime'])[0].booked == Book.objects.filter(timeid=u['vtime'])[0].maxnum:
            return HttpResponse("Full")
        # 将该日期预约总人数加一，并向前端返回录入成功
        elif Book.objects.filter(timeid=u['vtime'])[0].booked < Book.objects.filter(timeid=u['vtime'])[0].maxnum:
            book_serializer = Vistorserializer(data=u)
            stemp = Book.objects.filter(timeid=u['vtime'])[0].booked
            Book.objects.filter(timeid=u['vtime'])[0].booked = stemp + 1
            if book_serializer.is_valid(raise_exception=True):
                book_serializer.save()
                return HttpResponse("yeah")
            else:
                return HttpResponse(HttpResponseBadRequest)


@csrf_exempt
def loginAdmin(request):
    if request.method == 'POST':  # 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body  # JSON数据序列化

        if Manager.objects.filter(mid=u['mid']).count() == 0:
            return HttpResponse("defeat")  # 若查询数据库显示用户输入的id不存在，则返回"defeat"

        temp = Manager.objects.get(mid=u['mid'])
        temp_serializer = Managerserializer(temp)
        if u['mpw'] == temp_serializer.data['mpw']:
            return JsonResponse("Login success", safe=False)  # 若查询数据库显示用户输入的id存在且密码完全符合，则返回"登录成功。
        else:
            return HttpResponse("defeat")  # 密码匹配失败，返回失败


@csrf_exempt
def logininpector(request):
    if request.method == 'POST':# 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body# JSON数据序列化
        if Inspector.objects.filter(inspectorid=u['inspectorid']).count() == 0:# 若查询数据库显示用户输入的id不存在，则返回"defeat"
            return HttpResponse("defeat")

        temp = Inspector.objects.get(inspectorid=u['inspectorid'])
        temp_serializer = Inspectorserializer(temp)

        if u['inspectorpw'] == temp_serializer.data['inspectorpw']:
            return JsonResponse("Login success", safe=False) # 若查询数据库显示用户输入的id存在且密码完全符合，则返回"登录成功。
        else:
            return HttpResponse("defeat") # 密码匹配失败，返回失败


@csrf_exempt
def lake(request):
    if request.method == 'GET':# 接收到GET类型的请求
        lake = Lake.objects.all()#查询该园区所有的湖泊
        lake_serializer = Lakeserializer(lake, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": lake_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def sluice(request):
    if request.method =='GET':
        Lake.objects.all().update(gatestate=False)
        return HttpResponse("aaa")
    if request.method == 'POST':# 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body['lakeid']# JSON数据序列化
        p = Lake.objects.filter(lakeid=u)[0].waterlevel
        # 将指定id的湖泊状态设为开闸放水，并且每次放水都需要减少10水位
        if p > 50:
            Lake.objects.filter(lakeid=u).update(gatestate=True, waterlevel=p - 10)
            lakes = Lake.objects.filter(lakeid=u)
            lake_serializer = Lakeserializer(lakes, many=True)
            return JsonResponse('Can you play it again?', safe=False)
        else:
            # Lake.objects.all().update(gatestate=False,waterlevel=p+100)
            return JsonResponse("No!The water level is too low！", safe=False)# 若水位降至50以下，则返回开闸失败信息



@csrf_exempt
def road(request):
    if request.method == 'GET':# 接收到GET类型的请求
        road = Road.objects.all()#查询该园区所有的路
        road_serializer = Roadserializer(road, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": road_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def roadmaintenance(request):
    if request.method == 'GET':# 接收到GET类型的请求
        Road.objects.all().update(potholesnum=0)#将园区所有路的状态更新为无坑洼
        return JsonResponse("roadok!", safe=False)#返回状态更新完成

    if request.method == 'POST':# 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body['roadid']# JSON数据序列化
        Road.objects.filter(roadid=u).update(potholesnum=0)#将指定id的道路状态设置为无坑洼
        roads = Road.objects.filter(roadid=u)
        road_serializer = Roadserializer(roads, many=True)
        return JsonResponse("It's finished.", safe=False)#返回状态更新完成

    if request.method == 'DELETE':#接收到DELETE类型数据
        json_body = JSONParser().parse(request)
        u = json_body['roadid']# JSON数据序列化
        Road.objects.filter(roadid=u).update(potholesnum=1)#将指定id的道路状态设置为有坑洼
        roads = Road.objects.filter(roadid=u)
        road_serializer = Roadserializer(roads, many=True)
        return JsonResponse("add finished.", safe=False)#返回状态更新完成



@csrf_exempt
def tree(request):# 接收到GET类型的请求
    if request.method == 'GET':
        tree = Tree.objects.all()#查询该园区所有的树木
        tree_serializer = Treeserializer(tree, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": tree_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def killinsects(request):
    if request.method == 'GET':# 接收到GET类型的请求
        Tree.objects.all().update(insectbugs=True)#将园区所有树木状态更新为无害虫
        return JsonResponse("HAOYE!", safe=False)#返回状态更新完成

    if request.method == 'POST':# 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body['treeid']# JSON数据序列化
        Tree.objects.filter(treeid=json_body['treeid']).update(insectbugs=True)#将指定id的树木状态设置为无害虫
        trees = Tree.objects.filter(treeid=json_body['treeid'])
        tree_serializer = Treeserializer(trees, many=True)
        return JsonResponse("Okay. Oh", safe=False)#返回状态更新完成

    if request.method == 'DELETE':#接收到DELETE类型请求
        json_body = JSONParser().parse(request)
        u = json_body['treeid']# JSON数据序列化
        Tree.objects.filter(treeid=json_body['treeid']).update(insectbugs=False)#将指定id的树木状态设置为有害虫
        trees = Tree.objects.filter(treeid=json_body['treeid'])
        tree_serializer = Treeserializer(trees, many=True)
        return JsonResponse("add complete", safe=False)#返回状态更新完成



@csrf_exempt
def Inspectordelete(request):
    if request.method == 'DELETE':#接收到DELETE类型请求
        json_body = JSONParser().parse(request)
        u = json_body# JSON数据序列化
        if Inspector.objects.filter(inspectorid=u['inspectorid']).count() == 0:# 查询指定id的监测员，若无此人则返回不存在
            return HttpResponse("bucunzai")
        else:
            Inspector.objects.filter(inspectorid=u['inspectorid']).delete()# 查询指定id的监测员，若有此人则删除此用户
            return HttpResponse("deleteover")# 返回已删除

    if request.method == 'POST':# 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body# JSON数据序列化
        if Inspector.objects.filter(inspectorid=u['inspectorid']).count() == 0:
            inspector_serializer = Inspectorserializer(data=u)# 查询数据库，若不存在此人，则使用ORM方法存储此监测员信息
            if inspector_serializer.is_valid(raise_exception=True):
                inspector_serializer.save()
                return HttpResponse("yeah")# 增加监测员成功，返回成功信息
            else:
                return HttpResponse(HttpResponseBadRequest)#增加失败
        else:
            return HttpResponse("cunzai")#已存在，增加失败


@csrf_exempt
def toilet(request):
    if request.method == 'GET':# 接收到GET类型的请求
        toilet = Toilet.objects.all()#查询该园区所有的厕所
        toilet_serializer = Toiletserializer(toilet, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": toilet_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def wcclean(request):
    if request.method == 'GET':# 接收到GET类型的请求
        Toilet.objects.all().update(toiletclean=False)  #将园区所有厕所状态更新为已清扫
        return JsonResponse("wcok!", safe=False)#返回状态更新完成

    if request.method == 'POST':# 接收到POST类型的请求
        json_body = JSONParser().parse(request)
        u = json_body['toiletid']
        Toilet.objects.filter(toiletid=u).update(toiletclean=True)#将指定id的厕所状态设置为已清扫
        toilets = Toilet.objects.filter(toiletid=u)
        toilet_serializer = Toiletserializer(toilets, many=True)
        return JsonResponse("clean over", safe=False)#返回状态更新完成

    if request.method == 'DELETE':#接收到DELETE类型请求
        json_body = JSONParser().parse(request)
        u = json_body['toiletid']
        Toilet.objects.filter(toiletid=u).update(toiletclean=False)#将指定id的厕所状态设置为未清扫
        toilets = Toilet.objects.filter(toiletid=u)
        toilet_serializer = Toiletserializer(toilets, many=True)
        return JsonResponse("clean over", safe=False)#返回状态更新完成


@csrf_exempt
def Park(request):
    if request.method == 'GET':# 接收到GET类型的请求
        park = Parking.objects.all()#查询该园区所有的停车场状态
        Parking_serializer = Parkingserializer(park, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": Parking_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def get_Visitor(request):
    if request.method == 'GET':# 接收到GET类型的请求
        vistors = Visitor.objects.all()#查询该园区所有的游客预约状态
        vistors_serializer = Vistorserializer(vistors, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": vistors_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def Inspectorlook(request):
    if request.method == 'GET':# 接收到GET类型的请求
        inspector = Inspector.objects.all()#查询该园区所有的监测员状态
        Inspector_serializer = Inspectorserializer(inspector, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": Inspector_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)


@csrf_exempt
def Managelook(request):
    if request.method == 'GET':# 接收到GET类型的请求
        manages = Manager.objects.all()#查询该园区所有的管理员状态
        Manager_serializer = Managerserializer(manages, many=True)
        context = {
            "code": 0,
            "msg": "",
            "count": 1000,
            "data": Manager_serializer.data
        }# 规范化为前端适用的格式，通过接口传入前端
        return JsonResponse(context, safe=False)



@csrf_exempt
def get_data(request):
    data = [{
        "id": 1,
        "username": "12",
        "sex": 1000,  # 所有数据数量
        "city": 2000,  # 需要查询出来数据
        "sign": 'nihao',
        "experience": 'nihao',
        "score": 123,
        "clasify": 'lvshi',
        "wealth": 123,
    }]
    context = {
        "code": 0,
        "msg": "1",
        "count": 500,
        "data": data
    }
    return JsonResponse(context, safe=False)
