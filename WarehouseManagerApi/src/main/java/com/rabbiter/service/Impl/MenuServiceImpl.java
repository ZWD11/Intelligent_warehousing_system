package com.rabbiter.service.Impl;

import com.rabbiter.entity.Menu;
import com.rabbiter.mapper.MenuMapper;
import com.rabbiter.service.MenuService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 */
@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements MenuService {

}
