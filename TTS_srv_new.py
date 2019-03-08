from roboy_cognition_msgs.srv import Talk
from combine import Comb
import rclpy
from rclpy.node import Node


class Soncreo_TTS(Node):

    def __init__(self):
        super().__init__('soncreo_tts')
        self.srv = self.create_service(Talk, '/roboy/cognition/speech/synthesis/talk', self.talk_callback)
        print("Ready to /roboy/cognition/speech/synthesis/talk")

        self.c=Comb()
        print("speech synthesis is ready now")
        self.c.inference_audio("Speech synthesis is ready now")

    def talk_callback(self, request, response):

        response.success = True  # evtl.  return {'success':True}
        self.get_logger().info('Incoming Text: %s' % (request.text))
        self.c.inference_audio(request)
        return response


def main(args=None):
    rclpy.init(args=args)

    soncreo_tts = Soncreo_TTS()
    soncreo_tts.talk_callback("hello there.")

    rclpy.spin(soncreo_tts)

    rclpy.shutdown()


if __name__ == '__main__':
    main()