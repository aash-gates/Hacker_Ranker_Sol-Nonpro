<?php

Class Node
{

        public $marked;
        public $distance;
        public $edges;

        public function __construct()
        {
                $this->marked = false;
                $this->distance = PHP_INT_MAX;
                $this->edges = array();
        }

}

Class Edge
{

        public $node1;
        public $node2;
        public $weight;
        public $id;

        public function get_other_node(&$node)
        {
                if ($node == null)
                        return $this->node1;
                if ($node === $this->node1)
                        return $this->node2;
                if ($node === $this->node2)
                        return $this->node1;
        }

}

$fp = fopen("php://stdin", "r");
fscanf($fp, "%d %d", $nodeCount, $edgeCount);


$nodeArray = array();
for ($j = 0; $j < $nodeCount; $j++)
{
        $nodeArray[] = new Node();
}

$pq = new SplPriorityQueue();
$mst = array();


for ($j = 0; $j < $edgeCount; $j++)
{
        fscanf($fp, "%d %d %d", $node1, $node2, $weight);

        $node1--;
        $node2--;

        $edge = new Edge();
        $edge->node1 = $nodeArray[$node1];
        $edge->node2 = $nodeArray[$node2];
        $edge->weight = $weight;
        $edge->id = $j;

        $nodeArray[$node1]->edges[] = $edge;
        $nodeArray[$node2]->edges[] = $edge;
}


fscanf($fp, "%d", $startNode);
$startNode--;

$startNode = $nodeArray[$startNode];
foreach ($startNode->edges as &$edge)
{
        $pq->insert($edge, $edge->weight * -1);
}


while (!$pq->isEmpty())
{
        $edge = $pq->extract();

        $node1 = $edge->node1;
        $node2 = $edge->node2;

        if ($node1->marked && $node2->marked)
        {
                continue;
        }

        $mst[] = $edge;

        if (!$node1->marked)
        {
                $node1->marked = true;
                foreach ($node1->edges as &$edge)
                {
                        $pq->insert($edge, $edge->weight * -1);
                }
        }
        if (!$node2->marked)
        {
                $node2->marked = true;
                foreach ($node2->edges as &$edge)
                {
                        $pq->insert($edge, $edge->weight * -1);
                }
        }
}

$total = 0;

foreach ($mst as $item)
{
        $total += $item->weight;
}

echo $total . "\n";
