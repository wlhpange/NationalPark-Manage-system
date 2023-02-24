import parkms.views
from django.contrib import admin
from django.urls import path,include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('park_ms/',include('parkms.urls')),

    path('appointment/',parkms.views.appointment),

    path('adminlogin/',parkms.views.loginAdmin),
    path('inspectorlogin/',parkms.views.logininpector),

    path('get_road/', parkms.views.road),
    path('roadmain/', parkms.views.roadmaintenance),

    path('get_lake/', parkms.views.lake),
    path('lakeout/', parkms.views.sluice),

    path('get_tree/', parkms.views.tree),
    path('killinsects/', parkms.views.killinsects),

    path('get_toilet/', parkms.views.toilet),
    path('wcclean/', parkms.views.wcclean),

    path('get_park/',parkms.views.Park),
    path('get_visitor/',parkms.views.get_Visitor),
    path("inspectorlook/", parkms.views.Inspectorlook),
    path("managelook/",parkms.views.Managelook),

    path('deleteinspector/',parkms.views.Inspectordelete),
]
