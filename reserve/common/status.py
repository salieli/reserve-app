from enum import Enum


class Reserve_Status(Enum):
    AUDITING = 0    # 正在审核
    PASSED = 1      # 已通过审核
    REJECTED = 2    # 已被拒绝
    CANCELLED = 3   # 已取消


# 用于查询中判断是查找过去还是之后的记录或者是所有的记录
class Data_Status(Enum):
    BEFORE = 0      # 以前的
    AFTER = 1       # 之后的
    ALL = 2         # 所有的
