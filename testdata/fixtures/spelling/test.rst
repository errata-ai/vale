Some text:

-  ``isBarrierEdge(DataFlow::Node src, DataFlow::Node trg)`` is a variant of ``isBarrier(nd)`` that allows specifying barrier *edges* in addition to barrier nodes; again, ``isSanitizerEdge`` is the corresponding predicate for taint tracking;
-  ``isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg)`` allows specifying custom additional flow steps for this analysis; ``isAdditionalTaintStep`` is the corresponding predicate for taint tracking configurations.

Lots more text.

.. vale off

For example, in the assignment ``s2 = s1.substring(i)``, the value of ``s1`` influences the value of ``s2``, because ``s2`` is assigned a substring of ``s1``.

.. vale on

Hey oh!
