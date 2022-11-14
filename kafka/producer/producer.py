from data_generator import DataGenerator

from kafka import KafkaProducer
from kafka.errors import KafkaError
import json
import random
import time

data_gen = DataGenerator()


class Producer():
    def __init__(self, bootstrap_servers, init_user_count=100):
        self.init_user_count = init_user_count
        self.user_topic = 'User'
        self.order_topic = 'Order'

        # Kafka producer 생성
        self.producer = KafkaProducer(
            bootstrap_servers=bootstrap_servers,
            value_serializer=lambda m: json.dumps(m).encode('utf-8')
        )

    def send_message(self, topic, key=None, value={}):
        try:
            future = self.producer.send(topic, key=key, value=value)
            assert future.succeeded
        except KafkaError as ke:
            print("KafkaLogsProducer error sending log to Kafka: %s", ke)
        except Exception as e:
            print("KafkaLogsProducer exception sending log to Kafka: %s", e)

    def init_user(self):
        for _ in range(self.init_user_count):
            self.send_message(self.user_topic, value=data_gen.add_user())

    def run(self, user_count_in_loop, ratio_order_user=0.1, inter_message_second=0.5, inter_iter_second=1):
        '''
        producer를 실행하여 user와 order 메시지를 브로커에 보내는 함수

        init_user를 실행하여 초기 user들을 생성하고 브로커에 보낸 후 user와 order를 꾸준히 특정 비율로 번갈아 보낸다.

        Args:
            user_count_in_loop : 하나의 for loop에 생성될 user 수
            ratio_order_user : 지금까지 생성된 user에 이 값의 비율만큼 order가 생성됨
                ex) 현재까지 생성된 user가 100명이고 이 값이 0.1이면 해당 for loop에서는 100*0.1=10개의 order 생성
            inter_sleep_second : 각 메시지마다 몇 초씩 쉴지
        '''

        run_start = time.time()

        self.init_user()
        data_gen.get_data_status()  # 데이터 현황 출력
        print(f'init user done\n\n')

        for i in range(1000):
            iter_start = time.time()

            order_count_in_loop = int(data_gen.user_number * ratio_order_user)
            order_count_in_loop = order_count_in_loop if order_count_in_loop > 0 else 1

            topics = [self.user_topic] * user_count_in_loop + \
                [self.order_topic] * order_count_in_loop
            random.shuffle(topics)

            for topic in topics:
                if topic == self.user_topic:
                    value = data_gen.add_user()
                elif topic == self.order_topic:
                    value = data_gen.add_order()

                self.send_message(topic, value=value)

                time.sleep(inter_message_second)

            print(
                f'Iteration {i} finished in {time.time() - iter_start} seconds')
            print(f'Process {len(topics)} messages in this iteration')
            print(f'Running time is {time.time() - run_start} seconds')

            data_gen.get_data_status()  # 데이터 현황 출력

            time.sleep(inter_iter_second)

            print('\n\n')

        # batch에 남아있는 메시지들을 전부 broker로 전송
        self.producer.flush()
        print(f'loop {i} end\n\n')
