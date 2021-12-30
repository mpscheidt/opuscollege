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

package org.uci.opus.util;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

/**
 * Dummy implementation of the Map interface that only leaves
 * the get(Object) method unimplemented.
 * Useful for method calls from JSP with one single parameter.
 * @author markus
 *
 */
public abstract class DummyMap<K, V> implements Map<K, V> {

    public Collection<V> values() {return null;}
    public V put(K key, V value) {return null;}
    public Set<K> keySet() {return null;}
    public boolean isEmpty() {return false;}
    public int size() {return 0;}
    public void putAll(Map<? extends K, ? extends V> t) {}
    public void clear() {}
    public boolean containsValue(Object value) {return false;}
    public V remove(Object key) {return null;  }
    public boolean containsKey(Object key) {return false;}
    public Set<Map.Entry<K,V>> entrySet() {return null;}

    // subclasses should override this method call their method with obj as the parameter
    public abstract V get(Object obj);
}
