import 'bootstrap/dist/css/bootstrap.css';
import axios from 'axios'
import { Container, Row, Col, Card, CardGroup } from 'react-bootstrap';
import { useState, useEffect } from 'react';

export default function Home() {
  const [tab, setTab] = useState('All');
  const [donuts, setDonuts] = useState();
  const [display, setDisplay] = useState([]);

  useEffect(() => {
    axios.get('http://localhost/api/hello').then(response => {
      setDonuts(response.data);
      setDisplay(response.data);
    });
  }, [])

  if (!display) return <div>Loading...</div>

  return (
    <Container className='App mt-3'>
      <h1><b>DOUGHNUTS</b></h1>
      <p className='Subtext'>Daily selection varies by shop</p>
      <Row className='mb-5'>
        <Col xs='2' onClick={() => {setTab('All'); setDisplay(donuts);}}><span className={tab === 'All' ? 'Selected Tab' : 'Tab'}>ALL</span></Col>
        <Col xs='2' onClick={() => {setTab('Iced'); setDisplay(donuts.filter(el => el.Type === 'Iced'));}}><span className={tab === 'Iced' ? 'Selected Tab' : 'Tab'}>ICED</span></Col>
        <Col xs='2' onClick={() => {setTab('Glazed'); setDisplay(donuts.filter(el => el.Type === 'Glazed'));}}><span className={tab === 'Glazed' ? 'Selected Tab' : 'Tab'}>GLAZED</span></Col>
        <Col xs='2' onClick={() => {setTab('Filled'); setDisplay(donuts.filter(el => el.Type === 'Filled'));}}><span className={tab === 'Filled' ? 'Selected Tab' : 'Tab'}>FILLED</span></Col>
        <Col xs='2' onClick={() => {setTab('Cake'); setDisplay(donuts.filter(el => el.Type === 'Cake'));}}><span className={tab === 'Cake' ? 'Selected Tab' : 'Tab'}>CAKE</span></Col>
        <Col xs='2' onClick={() => {setTab('Chocolate'); setDisplay(donuts.filter(el => el.Type === 'Chocolate'));}}><span className={tab === 'Chocolate' ? 'Selected Tab' : 'Tab'}>CHOCOLATE</span></Col>
      </Row>
      <Row>
        <CardGroup>
          {display.map(el => {
            return (
              <Col xs='3'>
                <Card border='light' className='mb-3' style={{'min-height': '25rem'}}>
                  <Card.Img src={el.Image} style={{'max-height':'20rem', 'width': 'auto'}}/>
                  <Card.Body/>
                  <Card.Title>{el.Name}</Card.Title>
                </Card>
              </Col>
            )
          })}
        </CardGroup>
      </Row>
    </Container>
  );
}
