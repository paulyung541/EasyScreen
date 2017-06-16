#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json

class Setting(object):
    def __init__(self, dimen_name, dimen_num, dimen_step, sp_name, sp_num, sp_step):
        self.__dimen_name = dimen_name
if __name__ == '__main__':
    d = dict(name="李", age=20, sex=True)
    # print(json.dumps(d))

    # a = json.load(open('setting.json', 'r', encoding='UTF-8'))
    # print(type(a))

    a = Setting();
