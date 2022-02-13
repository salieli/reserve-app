import datetime
import calendar

# 分页功能*************
class PageInfo(object):
    def __init__(self, current_page, per_page):
        try:
            self.current_page = int(current_page)
        except Exception as e:
            self.current_page = 1

        self.per_page = per_page

    def start(self):
        return (self.current_page-1)*self.per_page

    def end(self):
        return self.current_page*self.per_page
# 分页功能*************

# 日期功能**************基于现在确定之前或者之后多少天的日期


class DateRange:
    def __init__(self, pervious_or_next, select_range):
        now = datetime.datetime.now()
        self.select_range = select_range
        this_month_days = calendar.monthrange(now.year, now.month)[1]
        # 前14天
        if pervious_or_next == 'pervious':
            self.end_ = datetime.date(now.year, now.month, now.day)

            if now.day-select_range <= 0:
                previous_month_days = calendar.monthrange(
                    now.year, now.month-1)[1]
                self.start_ = datetime.date(
                    now.year, now.month-1, previous_month_days+now.day-select_range)
            else:
                self.start_ = datetime.date(
                    now.year, now.month, now.day-select_range)

        # 后14天
        elif pervious_or_next == 'next':
            self.start_ = datetime.date(now.year, now.month, now.day)
            if now.day+select_range <= this_month_days:
                self.end_ = datetime.date(
                    now.year, now.month, now.day + select_range)
            else:
                self.end_ = datetime.date(
                    now.year, now.month+1, select_range+now.day-this_month_days)
