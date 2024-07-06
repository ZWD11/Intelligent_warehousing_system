import re
from flask import Flask, request, jsonify
from flask_cors import CORS
from sqlalchemy import create_engine, text
import pandas as pd
import requests

app = Flask(__name__)
CORS(app)

username = 'root'
password = '12345678'
host = 'localhost'
database = 'warehouse_manager'
engine = create_engine(f'mysql+pymysql://{username}:{password}@{host}/{database}')
connection = engine.connect()

def remove_markdown_syntax(sql_query):
    clean_query = re.sub(r'```sql|```', '', sql_query)
    return clean_query.strip()

def natural_language_to_sql(api_url, api_key, model, nl_query):
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = {
        'model': model,
        'messages': [{'role': 'user', 'content': f"我将告诉你数据库中每张表的每一列的名字及其含义。请记住这些信息，并仅在我提供自然语言查询时输出对应的 SQL 语句，禁止输出任何其他内容包括文字。以下是数据库每张表的列及其含义：\
                    1. user（用户） 表 (id: 用户 id (主键), no: 账号名, name: 用户名, password: 账号密码, age: 用户年龄, sex: 用户性别 (sex=1: 男, sex=0: 女), phone: 用户电话号码, role_id: 角色类别 (role_id=0: 超级管理员, role_id=1: 管理员, role_id=2: 普通用户), isValid: 账户是否有效 (isValid=Y: 有效, isValid=N: 无效));\
                    2. storage（仓库信息） 表 (id: 仓库 id (主键), name: 仓库名字, remark: 仓库备注);\
                    3. goodstype（商品类型） 表 (id: 商品类型 id (主键), name: 商品类型名字, remark: 商品类型备注);\
                    4. goods（商品信息） 表 (id: 物品信息 id (主键), name: 物品名字, storage: 对应 storage 表的仓库 id, goodsType: 对应商品类型表的商品类型 id, count: 商品数量, remark: 商品备注);\
                    5. record（出入库操作记录） 表 (id: 操作记录 id (主键), goods: 对应商品信息表的商品信息 id, userId: 对应用户表的用户 id, admin_id: 对应用户表的管理员 id, count: 操作对应商品的数量(count>0: 入库, count<0: 出库), createtime: 操作时间, remark: 操作记录备注);\
                    将以下自然语言查询转换为 SQL 查询，并仅输出那一句 SQL 语句即可，不能输出其他任何内容包括文字：{nl_query}"}],
        'max_tokens': 10000
    }
    response = requests.post(api_url, headers=headers, json=data)
    if response.status_code == 200:
        result = response.json()
        if 'choices' in result and len(result['choices']) > 0:
            sql_query = result['choices'][0]['message']['content']
            return remove_markdown_syntax(sql_query)
        else:
            return "Error: The response does not contain 'choices' or 'message' with 'content'."
    else:
        return f"Error: {response.status_code}, {response.json()}"

def execute_sql_query(sql_query):
    try:
        if sql_query.strip().lower().startswith("select"):
            df = pd.read_sql(sql_query, connection)
            return df
        else:
            with engine.begin() as conn:
                result = conn.execute(text(sql_query))
                return f"Query executed successfully. Affected rows: {result.rowcount}"
    except Exception as e:
        return str(e)

def result_analysis(api_url, api_key, model, result, nl_query, sql_query):
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = {
        'model': model,
        'messages': [{'role': 'user', 'content': f"自然语言查询：{nl_query}\n生成的SQL查询：{sql_query}\n以下是查询结果：\n {result.to_string(index=False)}\n请对结果进行先输出之后再分析并输出分析结果。(注：下述我写的信息可能用不上，如果需要则匹配并输出，如果不需要则忽略同时不能进行输出，（role_id=0:超级管理员、role_id=1:管理员、role_id=2:普通用户）、（sex=1:男、sex=0:女）)"}],
        'max_tokens': 10000
    }
    response = requests.post(api_url, headers=headers, json=data)
    if response.status_code == 200:
        result = response.json()
        if 'choices' in result and len(result['choices']) > 0:
            analysis = result['choices'][0]['message']['content']
            return analysis
        else:
            return "Error: The response does not contain 'choices' or 'message' with 'content'."
    else:
        return f"Error: {response.status_code}, {response.json()}"

def chat2db(api_url, api_key, model, nl_query):
    sql_query = natural_language_to_sql(api_url, api_key, model, nl_query)
    if sql_query is None or sql_query.startswith("Error:"):
        return sql_query
    result = execute_sql_query(sql_query)
    if isinstance(result, pd.DataFrame):
        analysis = result_analysis(api_url, api_key, model, result ,nl_query, sql_query)
        return analysis
    else:
        return result

@app.route('/chat2db', methods=['POST'])
def handle_request():
    data = request.json
    nl_query = data.get('nl_query')
    api_url = 'https://api.zwdblog.online/v1/chat/completions'
    api_key = 'sk-NPqbzUdYaF0mlKKy28EfE38587Ba4e079b928e202933C94c'
    model = 'gemini-1.5-flash-latest'
    result = chat2db(api_url, api_key, model, nl_query)
    return jsonify(result=result)

if __name__ == '__main__':
    app.run(debug=True)
