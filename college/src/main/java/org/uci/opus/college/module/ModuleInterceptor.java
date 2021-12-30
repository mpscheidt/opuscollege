/*
 * ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 * 
 * The Original Code is Opus-College college module code.
 * 
 * The Initial Developer of the Original Code is
 * Center for Information Services, Radboud University Nijmegen.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 *   For Java files, see Javadoc @author tags.
 * 
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * 
 * ***** END LICENSE BLOCK *****
 */

package org.uci.opus.college.module;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.OrderComparator;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 * Intercepts all web requests to put the (ordered) list of modules in the
 * ModelAndView. Every module specific application context can define an
 * {@link org.uci.core.module.Module Module bean} that will be inserted into the
 * list of modules.
 * 
 * Right now, <code>header.jsp</code> renders the module list in a menu.
 */
public class ModuleInterceptor extends HandlerInterceptorAdapter implements ApplicationContextAware {

    private ApplicationContext applicationContext;

    private Logger log = LoggerFactory.getLogger(ModuleInterceptor.class);

    /**
     * We're getting access to the application context using
     * ApplicationContextAware, which is one of Spring's lifecycle interface.
     */
    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    @Override
    @SuppressWarnings("unchecked")
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {

        // first get all modules from the application context that we want to
        // include
        Map moduleMap = applicationContext.getBeansOfType(Module.class);

        // check the parent context as well for modules
        ApplicationContext parentContext = applicationContext.getParent();
        if (parentContext != null) {
            moduleMap.putAll(applicationContext.getParent().getBeansOfType(Module.class));
        }

        List<Module> modules = new ArrayList<Module>((Collection<Module>) moduleMap.values());

        // modules are org.springframework.core.Ordered. Let's sort them
        Collections.sort(modules, new OrderComparator());

        log.debug("Adding " + modules.size() + " modules to the model: " + modules);

        // add all the modules to the ModelAndView in order for header.jsp to
        // render them
        if (modelAndView != null) {
            modelAndView.addObject("modules", modules);
        }
    }

}
