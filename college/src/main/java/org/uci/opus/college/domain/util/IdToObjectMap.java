package org.uci.opus.college.domain.util;

import java.util.List;
import java.util.Map;

import org.uci.opus.util.DomainObjectMapCreator;
import org.uci.opus.util.DummyMap;

public class IdToObjectMap<T> extends DummyMap<Number, T> {

	private Map<Number, ? extends T> map;

	public IdToObjectMap(List<? extends T> list) {
		map = DomainObjectMapCreator.makeIdToObjectMap(list);
	}

	@Override
	public T get(Object obj) {
		return map.get(obj);
	}

}
