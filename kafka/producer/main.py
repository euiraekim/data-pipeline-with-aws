from producer import Producer

import argparse
import time

parser = argparse.ArgumentParser()
parser.add_argument('-bs', '--bootstrap-servers',
                    dest='bootstrap_servers', help='부트스트랩 서버 리스트')
parser.add_argument('-iuc', '--init-user-count',
                    dest='init_user_count', help='초기 user 수', default=10)
parser.add_argument('-uc', '--user-count-in-loop', dest='user_count_in_loop',
                    help='하나의 for loop에서 생성되는 user 수', default=10)
parser.add_argument('-r', '--ratio-order-user', dest='ratio_order_user',
                    help='하나의 for loop에서 order가 현재 user 수의 어떤 비율만큼 생성될 지', default=0.1)
parser.add_argument('-mt', '--inter-message-second', dest='inter_message_second',
                    help='하나의 메시지가 보내질 때마다 sleep하는 시간(s)', default=0.5)
parser.add_argument('-it', '--inter-iter-second', dest='inter_iter_second',
                    help='하나의 메시지가 보내질 때마다 sleep하는 시간(s)', default=1)
args = parser.parse_args()

bootstrap_servers = args.bootstrap_servers.split(',')
init_user_count = int(args.init_user_count)
user_count_in_loop = int(args.user_count_in_loop)
ratio_order_user = float(args.ratio_order_user)
inter_message_second = float(args.inter_message_second)
inter_iter_second = float(args.inter_iter_second)

if __name__ == '__main__':
    producer = Producer(bootstrap_servers, init_user_count=init_user_count)

    producer.run(user_count_in_loop, ratio_order_user,
                 inter_message_second=inter_message_second, inter_iter_second=inter_iter_second)
