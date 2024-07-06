package com.rabbiter.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.rabbiter.common.QueryPageParam;
import com.rabbiter.common.Result;
import com.rabbiter.entity.Menu;
import com.rabbiter.entity.User;
import com.rabbiter.service.Impl.SmsService;
import com.rabbiter.service.MenuService;
import com.rabbiter.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 *
 *  前端控制器：用户管理和管理员管理模块
 *
 */
@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private MenuService menuService;

    @Autowired
    private SmsService smsService;

    /*
     * 利用阿里云api接口发送手机验证码登录
     */
    // 用于存储手机号和验证码的Map
    private static final ConcurrentHashMap<String, String> phoneCodeMap = new ConcurrentHashMap<>();

    @PostMapping("/sendCode")
    public Result sendCode(@RequestBody HashMap<String, String> params) {
        String phone = params.get("phone");
        if (phone == null || phone.isEmpty()) {
            return Result.fail("手机号不能为空");
        }

        String code = String.valueOf(new Random().nextInt(899999) + 100000);
        phoneCodeMap.put(phone, code);
        boolean success = smsService.sendSms(phone, code);
        if (success) {
            return Result.success("验证码已发送");
        } else {
            return Result.fail("验证码发送失败");
        }
    }

    @PostMapping("/loginWithCode")
    public Result loginWithCode(@RequestBody HashMap<String, String> params) {
        String phone = params.get("phone");
        String code = params.get("code");
        if (phone == null || phone.isEmpty() || code == null || code.isEmpty()) {
            return Result.fail("手机号和验证码不能为空");
        }

        if (!code.equals(phoneCodeMap.get(phone))) {
            return Result.fail("验证码错误");
        }

        User user = userService.lambdaQuery().eq(User::getPhone, phone).one();
        if (user == null) {
            return Result.fail("用户不存在");
        }

        List<Menu> menuList = menuService.lambdaQuery()
                .like(Menu::getMenuright, user.getRoleId())
                .list();
        HashMap<String, Object> res = new HashMap<>();
        res.put("user", user);
        res.put("menu", menuList);

        phoneCodeMap.remove(phone);

        return Result.success(res);
    }

    /*
     * 查询全部用户
     */
    @GetMapping("/list")
    public List<User> list(){
        return userService.list();
    }

    /*
     * 根据账号或手机号查找用户
     */
    @GetMapping("/findByNo")
    public Result findByNo(@RequestParam String no){
        List list = userService.lambdaQuery()
                .eq(User::getNo,no)
                .list();
        return list.size()>0?Result.success(list):Result.fail();
    }

    @GetMapping("/findByPhone")
    public Result findByPhone(@RequestParam String phone){
        List list = userService.lambdaQuery()
                .eq(User::getPhone,phone)
                .list();
        return list.size()>0?Result.success(list):Result.fail();
    }

    /*
     * 新增用户
     */
    @PostMapping("/save")
    public Result save(@RequestBody User user){
        List<User> existingUsersByNo = userService.lambdaQuery()
                .eq(User::getNo, user.getNo())
                .list();
        if (existingUsersByNo.size() > 0) {
            return Result.fail("账号已经存在");
        }

        List<User> existingUserByPhone = userService.lambdaQuery()
                .eq(User::getPhone,user.getPhone())
                .list();
        if(existingUserByPhone.size() > 0){
            return Result.fail("手机号码已存在");
        }

        return userService.save(user)?Result.success():Result.fail();
    }

    /*
     * 更新用户
     */
    @PostMapping("/update")
    public Result update(@RequestBody User user){
        List<User> existingUsersByNo = userService.lambdaQuery()
                .eq(User::getNo, user.getNo())
                .ne(User::getId, user.getId())
                .list();
        if (existingUsersByNo.size() > 0) {
            return Result.fail("账号已经存在");
        }

        List<User> existingUsersByPhone = userService.lambdaQuery()
                .eq(User::getPhone, user.getPhone())
                .ne(User::getId, user.getId())
                .list();
        if (existingUsersByPhone.size() > 0) {
            return Result.fail("电话号码已经存在");
        }

        return userService.updateById(user)?Result.success():Result.fail();
    }

    /*
     * 用户登录：登录的时候一并将菜单信息也查询出来
     */
    @PostMapping("/login")
    public Result login(@RequestBody User user){
        //匹配账号和密码
        List list = userService.lambdaQuery()
                .eq(User::getNo,user.getNo())
                .eq(User::getPassword,user.getPassword())
                .list();

        if(list.size()>0){
            User user1 = (User)list.get(0);
            List<Menu> menuList = menuService.lambdaQuery()
                    .like(Menu::getMenuright,user1.getRoleId())
                    .list();
            HashMap res = new HashMap();
            res.put("user",user1);
            res.put("menu",menuList);
            return Result.success(res);
        }
        return Result.fail();
    }

    /*
     * 修改用户
     */
    @PostMapping("/mod")
    public boolean mod(@RequestBody User user){
        return userService.updateById(user);
    }
    
    /*
     * 新增或修改：存在用户则修改，否则新增用户
     */
    @PostMapping("/saveOrUpdate")
    public Result saveOrUpdate(@RequestBody User user){
        return userService.saveOrUpdate(user)?Result.success():Result.fail();
    }

    /*
     * 删除用户
     */
    @GetMapping("/del")
    public Result delete(Integer id){
        return userService.removeById(id)?Result.success():Result.fail();
    }

    /*
     * 模糊查询
     */
    @PostMapping("/listP")
    public Result query(@RequestBody User user){
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if(StringUtils.isNotBlank(user.getName())){
            wrapper.like(User::getName,user.getName());
        }
        return Result.success(userService.list(wrapper));
    }

    /*
     * 分页查询
     */
    @PostMapping("/listPage")
    public List<User> listPage(@RequestBody QueryPageParam query){
        HashMap param = query.getParam();
        String name = (String)param.get("name");
        System.out.println("name=>"+(String)param.get("name"));

        Page<User> page = new Page();
        page.setCurrent(query.getPageNum());
        page.setSize(query.getPageSize());

        LambdaQueryWrapper<User> lambdaQueryWrapper = new LambdaQueryWrapper();
        lambdaQueryWrapper.like(User::getName,name);


        IPage result = userService.page(page,lambdaQueryWrapper);

        System.out.println("total=>"+result.getTotal());

        return result.getRecords();
    }

    /*
     * 查询功能：根据前端表单输入的信息或者下拉框选择查询用户，并以分页的形式返回前端
     */
    @PostMapping("/listPageC1")
    public Result listPageC1(@RequestBody QueryPageParam query){
        HashMap param = query.getParam();
        String name = (String)param.get("name");
        String sex = (String)param.get("sex");
        String roleId = (String)param.get("roleId");

        Page<User> page = new Page();
        page.setCurrent(query.getPageNum());
        page.setSize(query.getPageSize());

        LambdaQueryWrapper<User> lambdaQueryWrapper = new LambdaQueryWrapper();
        if(StringUtils.isNotBlank(name) && !"null".equals(name)){
            lambdaQueryWrapper.like(User::getName,name);
        }
        if(StringUtils.isNotBlank(sex)){
            lambdaQueryWrapper.eq(User::getSex,sex);
        }
        if(StringUtils.isNotBlank(roleId)){
            lambdaQueryWrapper.eq(User::getRoleId,roleId);
        }

        IPage result = userService.pageCC(page,lambdaQueryWrapper);

        System.out.println("total=>"+result.getTotal());

        return Result.success(result.getRecords(),result.getTotal());
    }

}
