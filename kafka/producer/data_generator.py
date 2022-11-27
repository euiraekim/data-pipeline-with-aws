import random
from faker import Faker
from datetime import datetime

faker = Faker("ko_KR")


class DataGenerator():
    def __init__(self):
        # gender 초기화, random weight 설정
        self.gender = ['Men', 'Women']
        self.gender_weights = [60, 40]

        # 1차 분류 초기화, random weight 설정
        self.first_categories = ('Top', 'Bottom', 'Outerwear', 'Shoe', 'Skirt')
        self.first_category_weights = (40, 25, 15, 15, 5)

        # 2차 분류 초기화, random weight 설정
        self.second_categories = (
            ('Blouse', 'Shirt', 'Polo', 'Sweatshirt', 'Sweater'),
            ('Straight', 'Skinny', 'Wide leg', 'Cargo Pants', 'Boot-Cut'),
            ('Padded Jacket', 'Blazer', 'Trench Coat',
             'Zip Up Hoodie', 'Denim Jacket'),
            ('Marry Jane', 'Sling Back', 'Sneaker', 'Penny Loafer', 'Sandal'),
            ('Straight', 'Pencil', 'A-line', 'Slit', 'Wrap'),
        )
        self.second_category_weights = (
            (30, 20, 20, 20, 10),
            (40, 30, 20, 5, 5),
            (50, 35, 5, 5, 5),
            (30, 30, 25, 10, 5),
            (40, 30, 15, 10, 5)
        )

        # 이메일 초기화, random weight 설정
        self.emails = ('gmail.com', 'naver.com', 'kakao.com', 'hanmail.net', 'nate.com',
                       'yahoo.co.kr', 'dreamwiz.com', 'freechal.com', 'empal.com', 'hitel.net')
        self.email_weights = (25, 35, 15, 10, 5,
                              4, 2, 2, 1, 1)

        # 주소 초기화, random weight 설정
        self.addresses = ('Seoul', 'Busan', 'Daegu', 'Gwangju',
                          'Incheon', 'Daejeon', 'Ulsan', 'Gyeonggi',
                          'Gangwon', 'Chungcheongnam-do', 'Chungcheongbuk-do',
                          'Jeollanam-do', 'Jeollabuk-do', 'Gyeongsangnam-do',
                          'Gyeongsangbuk-do', 'Jeju')
        self.address_weights = (19, 6, 5, 3, 8,
                                3, 2, 23, 4, 5, 5, 3, 2, 6, 5, 1)

        self.users = []
        self.user_number = 1

        self.orders = []
        self.order_number = 1

    def add_user(self):
        # ex: aaa123@naver.com
        email = faker.email().split(
            '@')[0] + '@' + random.choices(self.emails, weights=self.email_weights, k=1)[0]

        gender = random.choices(
            self.gender, weights=self.gender_weights, k=1)[0]

        address = random.choices(
            self.addresses, weights=self.address_weights, k=1)[0]

        user = {
            'user_id': self.user_number,
            'name': faker.name(),
            'email': email,
            'phone_number': faker.phone_number(),
            'gender': gender,
            'address': address,
            'created_date': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }

        self.users.append(user)
        self.user_number += 1

        return user

    def add_order(self):
        user_id = random.randint(1, self.user_number)
        first_category_idx = random.choices(
            list(range(len(self.first_categories))), weights=self.first_category_weights, k=1)[0]
        first_category = self.first_categories[first_category_idx]
        second_category = random.choices(
            self.second_categories[first_category_idx], weights=self.second_category_weights[first_category_idx], k=1)[0]

        order = {
            'order_id': self.order_number,
            'user_id': user_id,
            'product_id': random.randint(1, 1000),
            'price': 500 * random.randint(1, 1000)
            'first_category': first_category,
            'second_category': second_category,
            'created_date': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }

        self.orders.append(order)
        self.order_number += 1

        return order

    def get_data_status(self):
        '''
        현재까지 생성되어 보내진 데이터의 현황을 출력함
        아래와 같이 출력된다.

        Data Status
          User count : 100
          Order count : 300
        '''
        print(
            f'Data Status\n  User count : {self.user_number - 1}\n  Order count : {self.order_number - 1}')
