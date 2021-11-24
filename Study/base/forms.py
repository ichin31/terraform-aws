from django.forms import ModelForm
from .models import Room

class RoomForm (ModelForm):
    class Meta:
        model = Room
        fields = '__all__'



        # https://www.youtube.com/watch?v=PtQiiknWUcI&t=1601s
        # 1:48:37