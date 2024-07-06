<template>
  <div class="chat-container">
    <div class="chat-box" ref="chatBox">
      <div v-for="(message, index) in messages" :key="index" class="message-container" :class="{'ai-message': message.from === 'ai', 'user-message': message.from === 'user'}">
        <div class="avatar">
          <img :src="message.from === 'ai' ? require('@/assets/bot.png') : require('@/assets/avatar1.jpg')" class="image">
        </div>
        <div class="message" v-html="message.text"></div>
      </div>
    </div>
    <div class="input-area">
      <div class="voice-control">
        <label @click="toggleVoice">
            <i :class="isRecording ? 'fas fa-stop' : 'fas fa-microphone'"></i>
        </label>
      </div>
      <div class="chat-input">
        <textarea v-model="nlQuery" @keydown="handleKeyDown" placeholder="请输入你想进行的操作,对话内容将每20分钟自动清除一次,Enter 发送,Shift + Enter 换行" ref="textarea"></textarea>
        <button @click="submitQuery">发送</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import marked from 'marked';
import autosize from 'autosize';

export default {
  data() {
    return {
      nlQuery: '',
      messages: JSON.parse(localStorage.getItem('messages')) || [
        {
          content: '我是你的智能助手，请问有什么需要帮助的吗？',
          from: 'ai',
          text: '<p>我是你的智能助手，请问有什么需要帮助的吗？</p >',
        },
      ],
      cleanStorageInterval: null,
      autoScroll: true,
      isRecording: false,
      recognition: null,
    };
  },
  mounted() {
    this.startCleanStorageInterval();
    autosize(this.$refs.textarea);
    this.scrollToBottom();
    this.setupVoiceRecognition();
  },
  beforeDestroy() {
    this.stopCleanStorageInterval();
    autosize.destroy(this.$refs.textarea);
  },
  methods: {
    toggleVoice() {
      if(this.isRecording){
        this.recognition.stop();
      }else{
        this.recognition.start();
        this.isRecording=true;
      }
    },
    setupVoiceRecognition() {
      const SpeechRecongnition = window.SpeechRecongnition || window.webkitSpeechRecognition;
      if(SpeechRecongnition){
        this.recognition = new SpeechRecongnition();
        this.recognition.lang = "zh-CN";
        this.recognition.continuous = false;

        this.recognition.onresult = (event) => {
          const transcript = event.results[0][0].transcript;
          this.nlQuery = transcript;
          this.submitQuery();
        };

        this.recognition.onerror = (event) => {
          console.error('Speech recognition error:', event);
        };

        this.recognition.onend = (event) => {
          this.isRecording = false;
        };
      } else {
        alert('抱歉，您的浏览器不支持语音识别功能。');
      }
    },
    async submitQuery() {
      if (this.nlQuery.trim() === '') return;
      const userMessage = this.nlQuery;
      const message = userMessage.replace(/\n/g,'<br>')
      this.nlQuery = '';
      autosize.destroy(this.$refs.textarea);

      this.messages.push({ from: 'user', text: marked(message) });
      this.saveConversations();
      this.scrollToBottom();

      try {
        const response = await axios.post('http://localhost:5000/chat2db', { nl_query: userMessage });
        const botMessage = response.data.result;
  
        this.simulateTyping(marked(botMessage));
        // this.speakText(botMessage);
      } catch (error) {
        console.error('Error:', error);
        this.messages.push({ from: 'ai', text: marked('An error occurred while processing your request.') });
        this.scrollToBottom();
      }
      this.saveConversations();
    },
    simulateTyping(text) {
      let index = 0;
      const message = { from: 'ai', text: '' };
      this.messages.push(message);

      const interval = setInterval(() => {
        if (index < text.length) {
          message.text += text[index++];
          this.scrollToBottom();
        } else {
          clearInterval(interval);
          this.saveConversations();
          this.scrollToBottom();
        }
      }, 20);
    },
    // speakText(text) {
    //   const utterance = new SpeechSynthesisUtterance(text);
    //   utterance.lang = 'zh-CN';
    //   window.speechSynthesis.speak(utterance);
    // },
    saveConversations() {
      localStorage.setItem('messages', JSON.stringify(this.messages));
    },
    startCleanStorageInterval() {
      this.cleanStorageInterval = setInterval(() => {
        console.log("clearing...")
        localStorage.removeItem("messages");
        this.messages = [
          {
            content: '我是你的智能助手，请问有什么需要帮助的吗？',
            from: 'ai',
            text: '<p>我是你的智能助手，请问有什么需要帮助的吗？</p >',
          },
        ];
      }, 20*60*1000);
    },
    stopCleanStorageInterval() {
      if(this.cleanStorageInterval){
        clearInterval(this.cleanStorageInterval);
        this.cleanStorageInterval = null;
      }
    },
    handleKeyDown(event) {
      if (event.keyCode == 13) {
        event.preventDefault();
        if (event.shiftKey) {
          event.preventDefault();
          const textarea = event.target;
          const start = textarea.selectionStart;
          const end = textarea.selectionEnd;
          const text = textarea.value;
          const newText = text.substring(0, start) + '\n' + text.substring(end);
          textarea.value = newText;
          textarea.setSelectionRange(start + 1, start + 1);
          console.log(textarea.value);
          this.nlQuery = textarea.value;
        } else {
          event.preventDefault();
          this.submitQuery();
        }
      }
    },
    scrollToBottom() {
      this.$nextTick(() => {
        if (this.autoScroll) {
          const chatBox = this.$refs.chatBox;
          chatBox.scrollTop = chatBox.scrollHeight;
        }
      });
    }
  }
};
</script>

<style scoped>
.chat-container {
  width: 100%;
  max-width: 1200px;
  margin: 20px auto;
  border: 1px solid #ccc;
  border-radius: 5px;
  display: flex;
  flex-direction: column;
  height: 560px;
}

.chat-box {
  flex: 1;
  padding: 10px;
  overflow-y: auto;
  border-bottom: 1px solid #ccc;
  &::-webkit-scrollbar {
    width: 6px; 
  }

  &::-webkit-scrollbar-track {
    background: transparent; 
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(0, 0, 0, 0.1); 
    border-radius: 5px; 
  }

  &::-webkit-scrollbar-thumb:hover {
    background: rgba(0, 0, 0, 0.2);
  }
}

.message-container {
  display: flex;
  align-items: flex-start;
  margin-bottom: 10px;
  line-height: 2;
}

.message {
  max-width: 81%;
  border-radius: 10px;
}

.user-message {
  flex-direction: row-reverse;
}

.user-message .message {
  background-color: #d4edda;
  padding: 10px;
  word-break: break-all; 
}

.ai-message .message {
  background-color: #f8d7da;
  padding: 25px;
  word-break: break-all;
}

pre {
  background-color: #1a1b26;
  padding: 10px;
  border-radius: 5px;
  overflow-x: auto;
  white-space: pre; 
  font-family: 'Consolas', 'Monaco', 'Menlo', monospace; 
  font-size: 15px;
}

code {
  background-color: inherit;
  font-family: inherit;
  font-size: inherit;
}

.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
}

.image {
  width: 50px;
  height: 50px;
  border-radius: 50%;
}

.input-area {
  padding: 15px 1px;
  background-color: white;
  border-top: 1px solid #ccc;
  border-radius: 2%;
}

textarea {
  background: white;
  font-size: 16px;
  width: 100%;
  height: auto;
  border-radius: 5px;
  padding: 10px;
  border: none;
  resize: none;
  flex-grow: 1;
  margin-right: 10px;
  outline: none;
  max-height: 120px;
  box-sizing: border-box;
}

.input-area button {
  padding: 8px 16px;
  background-color: rgba(36, 160, 255, 0.9);
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-size: 12px;
  white-space: nowrap;
  align-self: flex-end;
  height: 35px;
  margin-left: 10px;
}

.input-area button:hover {
  background-color: #0056b3;
}

.input-area button::before {
  content: '\f1d8';
  font-family: 'Font Awesome 5 Free';
  font-weight: 800;
  margin-right: 5px;
}

.chat-input {
  display: flex;
  align-items: flex-end;
  border-radius: 5px;
  border: 1px solid #ccc;
  margin-right: 10px;
  margin-left: 11px;
  padding: 10px;
}

.chat-input:focus-within {
  outline: none;
  border-color: rgb(136, 203, 119);
  box-shadow: 0 0 5px rgba(68, 176, 58, 0.5);
}

table {
  width: 100%;
  border-collapse: collapse;
  margin: 10px 0;
}

table, th, td {
  border: 1px solid #ddd;
}

th, td {
  padding: 8px;
  text-align: left;
}

th {
  background-color: #f2f2f2;
}

.code-block {
  overflow-x: auto;
  white-space: nowrap;
  background-color: #f8f8f8;
  padding: 10px;
  border-radius: 5px;
  margin: 10px 0;
}

.voice-control {
  margin-bottom: 10px;
  text-align: left;
  margin-left: 18px
}

.voice-control label {
  cursor: pointer;
  font-size: 16px;
  color: rgba(255, 165, 0, 0.9);
}

.voice-control label:hover {
  color: rgba(255, 140, 0, 0.9);
}
</style>
